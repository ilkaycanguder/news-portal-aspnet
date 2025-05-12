using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.OleDb;
using System.Configuration;
using System.Linq;
using NLog;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

namespace NewsPortal.Web
{
    public partial class Home : System.Web.UI.Page
    {
        private static readonly Logger Logger = LogManager.GetCurrentClassLogger();
        private string connectionString = ConfigurationManager.ConnectionStrings["NewsDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
                LoadNews();
            }
            this.DataBind();
        }

        protected void ddlCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadNews();
        }

        private void LoadCategories()
        {
            try
            {
                using (OleDbConnection conn = new OleDbConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT DISTINCT Category FROM News ORDER BY Category";
                    using (OleDbCommand cmd = new OleDbCommand(query, conn))
                    {
                        using (OleDbDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                ddlCategories.Items.Add(new ListItem(reader["Category"].ToString()));
                            }
                        }
                    }
                }
                Logger.Info("Kategoriler başarıyla yüklendi.");
            }
            catch (Exception ex)
            {
                Logger.Error(ex, "Kategoriler yüklenirken hata oluştu.");
                Response.Write($"<script>alert('Kategoriler yüklenirken bir hata oluştu: {ex.Message}');</script>");
            }
        }

        private void LoadNews()
        {
            try
            {
                ArrayList newsList = new ArrayList();
                using (OleDbConnection conn = new OleDbConnection(connectionString))
                {
                    conn.Open();
                    string query = @"SELECT NewsID, Title, Description, Category, Author, 
                                   PubDate, ImageUrl FROM News";

                    if (!string.IsNullOrEmpty(ddlCategories.SelectedValue))
                    {
                        query += " WHERE Category = ?";
                    }

                    query += " ORDER BY PubDate DESC";

                    using (OleDbCommand cmd = new OleDbCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(ddlCategories.SelectedValue))
                        {
                            cmd.Parameters.AddWithValue("@Category", ddlCategories.SelectedValue);
                        }

                        using (OleDbDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                News news = new News(
                                    Convert.ToInt32(reader["NewsID"]),
                                    reader["Title"].ToString(),
                                    //reader["Description"].ToString(),
                                    RemoveImgTags(reader["Description"].ToString()),
                                    reader["Category"].ToString(),
                                    reader["Author"].ToString(),
                                    Convert.ToDateTime(reader["PubDate"]).ToString("dd.MM.yyyy HH:mm"),
                                    reader["ImageUrl"].ToString()
                                );
                                newsList.Add(news);
                            }
                        }
                    }
                }

                if (newsList.Count > 0)
                {
                    // Haberleri kategorilere göre grupla
                    var groupedNews = newsList.Cast<News>()
                        .GroupBy(n => n.Category)
                        .Select(g => new { Category = g.Key, News = g.ToList() })
                        .ToList();

                    rptCategories.DataSource = groupedNews;
                    rptCategories.DataBind();
                    pnlNoNews.Visible = false;
                }
                else
                {
                    pnlNoNews.Visible = true;
                }

                Logger.Info($"Haberler başarıyla yüklendi. Toplam haber sayısı: {newsList.Count}");
            }
            catch (Exception ex)
            {
                Logger.Error(ex, "Haberler yüklenirken hata oluştu.");
                Response.Write($"<script>alert('Haberler yüklenirken bir hata oluştu: {ex.Message}');</script>");
            }
        }

        private string RemoveImgTags(string html)
        {
            return System.Text.RegularExpressions.Regex.Replace(html, "<img[^>]*>", "", System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        }

        public string TruncateText(string text, int maxLength, int newsId)
        {
            if (string.IsNullOrWhiteSpace(text))
                return "";

            string clean = Regex.Replace(text.Trim(), @"(\.{2,}|\…+)$", ""); // Sonundaki ... temizle

            if (clean.Length > maxLength)
            {
                int lastSpace = clean.LastIndexOf(' ', maxLength);
                if (lastSpace > 0)
                    clean = clean.Substring(0, lastSpace);

                return $"{clean}..."; // Uzunsa üç nokta ekle
            }

            return clean; // Kısaysa ekleme yapma
        }

    }
}