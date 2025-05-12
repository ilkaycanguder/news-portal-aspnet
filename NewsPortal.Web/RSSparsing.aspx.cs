using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using System.Net;
using System.IO;
using System.Text.RegularExpressions;
using System.Collections;
using System.Data.OleDb;
using System.Configuration;

namespace NewsPortal.Web
{
    public partial class RSSparsing : System.Web.UI.Page
    {
        private ArrayList newsList;
        private string connectionString = ConfigurationManager.ConnectionStrings["NewsDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                newsList = new ArrayList();
                Session["NewsList"] = newsList;
                rptNews.DataSource = null;
                rptNews.DataBind();
            }
        }

        protected void ddlRSSFeeds_SelectedIndexChanged(object sender, EventArgs e)
        {
            newsList = new ArrayList();
            LoadRSSFeed();
            Session["NewsList"] = newsList;
        }

        private void LoadRSSFeed()
        {
            try
            {
                string rssUrl = ddlRSSFeeds.SelectedValue;
                if (string.IsNullOrEmpty(rssUrl))
                {
                    rptNews.DataSource = null;
                    rptNews.DataBind();
                    return;
                }

                int newsId = 1;
                Dictionary<string, int> categoryCount = new Dictionary<string, int>();

                using (WebClient client = new WebClient())
                {
                    client.Encoding = System.Text.Encoding.UTF8;
                    string rssContent = client.DownloadString(rssUrl);
                    XDocument doc = XDocument.Parse(rssContent);

                    // Atom formatı için <entry> etiketlerini çek
                    var items = doc.Descendants().Where(x => x.Name.LocalName == "entry");
                    foreach (var item in items)
                    {
                        string title = item.Element(item.Name.Namespace + "title")?.Value ?? "";
                        string description = item.Element(item.Name.Namespace + "content")?.Value ?? "";
                        string category = GetCategoryFromSelectedFeed(ddlRSSFeeds.SelectedItem.Text);
                        string author = item.Element(item.Name.Namespace + "author")?.Element(item.Name.Namespace + "name")?.Value ?? "NTV";
                        string pubDate = item.Element(item.Name.Namespace + "published")?.Value ?? DateTime.Now.ToString();

                        // Tüm img etiketlerini bul
                        var imgMatches = Regex.Matches(description, "<img[^>]+src=['\"]([^'\"]+)['\"]", RegexOptions.IgnoreCase);
                        string imageUrl = "Content/Images/default-news.jpg";

                        // Her zaman ilk görseli al
                        if (imgMatches.Count >= 1)
                        {
                            imageUrl = imgMatches[0].Groups[1].Value;
                        }


                        // Açıklamadan tüm img etiketlerini kaldır
                        string plainDescription = Regex.Replace(description, "<img.*?>", string.Empty, RegexOptions.IgnoreCase);
                        // Kalan HTML etiketlerini de kaldır
                        plainDescription = Regex.Replace(plainDescription, "<.*?>", string.Empty);

                        News news = new News(newsId++, title, plainDescription, category, author, pubDate, imageUrl);
                        if (AddNewsToArrayList(news, categoryCount))
                            newsList.Add(news);
                    }
                }

                Session["NewsList"] = newsList;
                SaveNewsToDatabase();
                newsList.Sort(new NewsComparer());
                rptNews.DataSource = newsList;
                rptNews.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write("<pre>" + ex.ToString() + "</pre>");
            }
        }

        private string GetCategoryFromSelectedFeed(string feedText)
        {
            if (feedText.Contains("Son Dakika")) return "Son Dakika";
            if (feedText.Contains("Foto Galeri")) return "Foto Galeri";
            if (feedText.Contains("Video Galeri")) return "Video Galeri";
            if (feedText.Contains("Gündem")) return "Gündem";
            if (feedText.Contains("Türkiye")) return "Türkiye";
            if (feedText.Contains("Eğitim")) return "Eğitim";
            if (feedText.Contains("Ekonomi")) return "Ekonomi";
            if (feedText.Contains("Para")) return "Para";
            if (feedText.Contains("N-Life")) return "N-Life";
            if (feedText.Contains("Dünya")) return "Dünya";
            if (feedText.Contains("Yaşam")) return "Yaşam";
            if (feedText.Contains("Spor & Skor")) return "Spor & Skor";
            if (feedText.Contains("Spor")) return "Spor";
            if (feedText.Contains("Teknoloji")) return "Teknoloji";
            if (feedText.Contains("Sağlık")) return "Sağlık";
            if (feedText.Contains("Sanat")) return "Sanat";
            if (feedText.Contains("Seyahat")) return "Seyahat";
            if (feedText.Contains("Otomobil")) return "Otomobil";

            return "Genel"; // Varsayılan
        }


        // Step 4: Haberleri veritabanına kaydet
        private void SaveNewsToDatabase()
        {
            using (OleDbConnection conn = new OleDbConnection(connectionString))
            {
                conn.Open();
                foreach (News news in newsList)
                {
                    // Haberin daha önce kaydedilip kaydedilmediğini kontrol et
                    string checkQuery = "SELECT COUNT(*) FROM News WHERE Title = ?";
                    using (OleDbCommand checkCmd = new OleDbCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@Title", news.Title);
                        int count = (int)checkCmd.ExecuteScalar();

                        if (count == 0) // Haber daha önce kaydedilmemiş
                        {
                            string insertQuery = @"INSERT INTO News (Title, Description, Category, Author, PubDate, ImageUrl) 
                                                 VALUES (?, ?, ?, ?, ?, ?)";
                            using (OleDbCommand insertCmd = new OleDbCommand(insertQuery, conn))
                            {
                                insertCmd.Parameters.AddWithValue("@Title", news.Title);
                                insertCmd.Parameters.AddWithValue("@Description", news.Description);
                                insertCmd.Parameters.AddWithValue("@Category", news.Category);
                                insertCmd.Parameters.AddWithValue("@Author", news.Author);
                                insertCmd.Parameters.AddWithValue("@PubDate", news.PubDate);
                                insertCmd.Parameters.AddWithValue("@ImageUrl", news.ImageUrl);
                                insertCmd.ExecuteNonQuery();
                            }
                        }
                    }
                }
            }
        }

        // Step 3: ArrayList'e haber ekleme (kategori sınırlaması ile)
        private bool AddNewsToArrayList(News news, Dictionary<string, int> categoryCount)
        {
            if (!categoryCount.ContainsKey(news.Category))
            {
                categoryCount[news.Category] = 0;
            }

            if (categoryCount[news.Category] < 20)
            {
                categoryCount[news.Category]++;
                return true;
            }

            return false;
        }

        protected void btnGoHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx");
        }
    }

    // Haberleri tarihe göre sıralamak için karşılaştırıcı sınıf
    public class NewsComparer : IComparer
    {
        public int Compare(object x, object y)
        {
            News news1 = (News)x;
            News news2 = (News)y;

            DateTime date1, date2;
            if (DateTime.TryParse(news1.PubDate, out date1) && DateTime.TryParse(news2.PubDate, out date2))
            {
                return date2.CompareTo(date1); // En yeni haberler önce
            }
            return 0;
        }
    }
}