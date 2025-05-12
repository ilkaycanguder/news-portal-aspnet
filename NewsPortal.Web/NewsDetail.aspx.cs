using System;
using System.Data.OleDb;
using System.Configuration;
using NLog;

namespace NewsPortal.Web
{
    public partial class NewsDetail : System.Web.UI.Page
    {
        private static readonly Logger Logger = LogManager.GetCurrentClassLogger();
        private string connectionString = ConfigurationManager.ConnectionStrings["NewsDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string newsId = Request.QueryString["ID"];
                if (!string.IsNullOrEmpty(newsId))
                {
                    Logger.Info($"Haber detayı yükleniyor. Haber ID: {newsId}");
                    LoadNewsDetail(Convert.ToInt32(newsId));
                }
                else
                {
                    Logger.Warn("Haber ID parametresi bulunamadı.");
                    ShowError();
                }
            }
        }

        private void LoadNewsDetail(int newsId)
        {
            try
            {
                using (OleDbConnection conn = new OleDbConnection(connectionString))
                {
                    conn.Open();
                    string query = @"SELECT NewsID, Title, Description, Category, Author, 
                                   PubDate, ImageUrl FROM News WHERE NewsID = ?";

                    using (OleDbCommand cmd = new OleDbCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@NewsID", newsId);
                        using (OleDbDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Haber detaylarını yükle
                                lblTitle.Text = reader["Title"].ToString();
                                lblCategory.Text = reader["Category"].ToString();
                                lblAuthor.Text = reader["Author"].ToString();
                                lblPubDate.Text = Convert.ToDateTime(reader["PubDate"]).ToString("dd.MM.yyyy HH:mm");
                                ltlDescription.Text = reader["Description"].ToString(); // yeni
                                imgNews.ImageUrl = reader["ImageUrl"].ToString();
                                imgNews.AlternateText = reader["Title"].ToString();

                                // Görünürlük ayarları
                                pnlNewsDetail.Visible = true;
                                pnlError.Visible = false;

                                Logger.Info($"Haber detayı başarıyla yüklendi. Haber ID: {newsId}, Başlık: {reader["Title"]}");
                            }
                            else
                            {
                                Logger.Warn($"Haber bulunamadı. Haber ID: {newsId}");
                                ShowError();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error(ex, $"Haber detayı yüklenirken hata oluştu. Haber ID: {newsId}");
                Response.Write($"<script>alert('Haber detayı yüklenirken bir hata oluştu: {ex.Message}');</script>");
                ShowError();
            }
        }

        private void ShowError()
        {
            pnlNewsDetail.Visible = false;
            pnlError.Visible = true;
        }
    }
}