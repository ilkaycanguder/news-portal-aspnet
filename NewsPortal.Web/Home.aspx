<%@ Page Title="Ana Sayfa" Language="C#" MasterPageFile="~/Site.Master"
AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="NewsPortal.Web.Home"
%>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
  <div class="container" style="max-width: 1200px; margin-top: 48px">
    <h2 class="mb-4 fw-semibold text-center" style="letter-spacing: 0.5px">
      Güncel Haberler
    </h2>
    <div class="category-filter mb-4 d-flex justify-content-center">
      <asp:DropDownList
        ID="ddlCategories"
        runat="server"
        CssClass="form-select form-select-lg"
        AutoPostBack="true"
        OnSelectedIndexChanged="ddlCategories_SelectedIndexChanged"
      >
        <asp:ListItem Text="Tüm Kategoriler" Value="" />
      </asp:DropDownList>
    </div>
    <asp:Repeater ID="rptCategories" runat="server">
      <ItemTemplate>
        <div class="category-section mb-5">
          <h3
            class="category-title text-center mb-4 fw-bold"
            style="color: #2c3e50; position: relative"
          >
            <span
              style="
                background: #fff;
                padding: 0 15px;
                position: relative;
                z-index: 1;
              "
              ><%# Eval("Category") %></span
            >
            <div
              style="
                position: absolute;
                top: 50%;
                left: 0;
                right: 0;
                height: 1px;
                background: #e0e0e0;
                z-index: 0;
              "
            ></div>
          </h3>
          <div class="row g-4 justify-content-center">
            <asp:Repeater
              ID="rptNews"
              runat="server"
              DataSource='<%# Eval("News") %>'
            >
              <ItemTemplate>
                <div
                  class="col-lg-4 col-md-6 col-sm-12 d-flex align-items-stretch"
                >
                  <asp:HyperLink
                    ID="lnkNewsCard"
                    runat="server"
                    NavigateUrl='<%# $"~/NewsDetail.aspx?ID={Eval("NewsID")}" %>'
                    CssClass="text-decoration-none w-100"
                  >
                    <div class="news-card card shadow-sm border-0 mb-4">
                      <asp:PlaceHolder
                        runat="server"
                        Visible='<%# !Eval("ImageUrl").ToString().Contains("no-image-home.jpg") %>'
                      >
                        <div
                          class="news-image-wrapper card-img-top p-0"
                          style="background: #f5f5f5"
                        >
                          <asp:Image
                            ID="imgNews"
                            runat="server"
                            CssClass="news-img rounded-top"
                            ImageUrl='<%# Eval("ImageUrl") %>'
                            AlternateText='<%# Eval("Title") %>'
                          />
                        </div>
                      </asp:PlaceHolder>
                      <div
                        class="news-content-wrapper card-body d-flex flex-column"
                      >
                        <h5
                          class="news-title card-title mb-2 text-dark fw-bold"
                        >
                          <%# Eval("Title") %>
                        </h5>
                        <div
                          class="news-meta mb-2 small text-muted d-flex align-items-center gap-2"
                        >
                          <span class="badge bg-primary"
                            ><%# Eval("Category") %></span
                          >
                          <span class="news-author"
                            ><i class="fas fa-user"></i> <%# Eval("Author")
                            %></span
                          >
                          <span class="news-date"
                            ><i class="fas fa-calendar"></i> <%# Eval("PubDate")
                            %></span
                          >
                        </div>
                        <p class="news-desc card-text mt-auto">
                          <%# Eval("Description") %>
                        </p>
                      </div>
                    </div>
                  </asp:HyperLink>
                </div>
              </ItemTemplate>
            </asp:Repeater>
          </div>
        </div>
      </ItemTemplate>
    </asp:Repeater>
    <asp:Panel
      ID="pnlNoNews"
      runat="server"
      Visible="false"
      CssClass="text-center py-5"
    >
      <div class="no-news-message">
        <i class="fas fa-newspaper fa-3x mb-3 text-muted"></i>
        <h4 class="text-muted">Bu kategoride henüz haber bulunmamaktadır.</h4>
      </div>
    </asp:Panel>
  </div>

  <!-- Yukarı Çıkma Butonu -->
  <button id="scrollToTop" class="scroll-to-top" title="Yukarı Çık">
    <i class="fas fa-arrow-up"></i>
  </button>

  <style>
    body {
      background: #f8f9fa;
    }

    .category-section {
      position: relative;
    }

    .news-card {
      border-radius: 18px;
      box-shadow: 0 4px 24px rgba(0, 0, 0, 0.08);
      background: #fff;
      transition: box-shadow 0.2s, transform 0.2s;
      min-height: 420px;
      display: flex;
      flex-direction: column;
      cursor: pointer;
    }

    .news-card:hover {
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.13);
      transform: translateY(-6px) scale(1.01);
    }

    .news-image-wrapper {
      width: 100%;
      height: 210px;
      overflow: hidden;
      border-radius: 18px 18px 0 0;
      background: #f5f5f5;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .news-img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
      border-radius: 18px 18px 0 0;
    }

    .news-content-wrapper {
      flex: 1;
      display: flex;
      flex-direction: column;
      padding: 1.2rem 1.3rem 1.3rem 1.3rem;
    }

    .news-title {
      font-size: 1.13rem;
      font-weight: bold;
      margin-bottom: 0.5rem;
      min-height: 48px;
      line-height: 1.3;
    }

    .news-title a {
      color: #222;
      text-decoration: none;
    }

    .news-title a:hover {
      color: #007bff;
    }

    .news-meta {
      font-size: 0.97rem;
      color: #888;
      margin-bottom: 0.5rem;
      display: flex;
      gap: 0.7rem;
      align-items: center;
    }

    .news-meta .badge {
      font-size: 0.9rem;
      background: #007bff;
      color: #fff;
      border-radius: 12px;
      padding: 0.3em 0.8em;
    }

    .news-author,
    .news-date {
      color: #888;
    }

    .news-desc {
      font-size: 1.01rem;
      color: #444;
      margin-top: 0.5rem;
      display: -webkit-box;
      -webkit-line-clamp: 4;
      -webkit-box-orient: vertical;
      overflow: hidden;
      min-height: 80px;
    }

    .form-select {
      min-width: 200px;
      border-radius: 12px;
      padding: 0.6rem 1rem;
      font-size: 1rem;
      border: 1px solid #dee2e6;
      background-color: #fff;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    }

    .form-select:focus {
      border-color: #007bff;
      box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
    }

    @media (max-width: 992px) {
      .col-lg-4 {
        flex: 0 0 50%;
        max-width: 50%;
      }
    }

    @media (max-width: 768px) {
      .col-lg-4,
      .col-md-6 {
        flex: 0 0 100%;
        max-width: 100%;
      }

      .news-image-wrapper {
        height: 160px;
      }
    }

    @media (max-width: 576px) {
      body {
        padding: 0 0.75rem;
      }

      .container {
        padding-left: 0 !important;
        padding-right: 0 !important;
      }

      .news-grid {
        flex-direction: column;
        gap: 1.5rem;
      }

      .news-card {
        min-height: unset;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
      }

      .news-image-wrapper {
        height: 160px !important;
      }

      .news-content-wrapper {
        padding: 1rem;
      }

      .news-title {
        font-size: 1.05rem;
        min-height: unset;
      }

      .news-meta {
        flex-direction: column;
        align-items: flex-start;
        gap: 0.4rem;
        font-size: 0.85rem;
      }

      .news-desc {
        font-size: 0.95rem;
        -webkit-line-clamp: 5;
      }

      .form-select {
        width: 100%;
        font-size: 1rem;
        padding: 0.55rem 0.75rem;
      }
    }

    /* Yukarı Çıkma Butonu Stilleri */
    .scroll-to-top {
      position: fixed;
      bottom: 30px;
      right: 30px;
      width: 45px;
      height: 45px;
      border-radius: 50%;
      background-color: #007bff;
      color: white;
      border: none;
      cursor: pointer;
      display: none;
      align-items: center;
      justify-content: center;
      font-size: 1.2rem;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
      transition: all 0.3s ease;
      z-index: 1000;
    }

    .scroll-to-top:hover {
      background-color: #0056b3;
      transform: translateY(-3px);
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
    }

    .scroll-to-top.show {
      display: flex;
    }

    @media (max-width: 768px) {
      .scroll-to-top {
        bottom: 20px;
        right: 20px;
        width: 40px;
        height: 40px;
        font-size: 1rem;
      }
    }
  </style>

  <script type="text/javascript">
    // Yukarı çıkma butonu için JavaScript kodu
    window.onscroll = function () {
      var scrollButton = document.getElementById("scrollToTop");
      if (
        document.body.scrollTop > 300 ||
        document.documentElement.scrollTop > 300
      ) {
        scrollButton.classList.add("show");
      } else {
        scrollButton.classList.remove("show");
      }
    };

    document.getElementById("scrollToTop").onclick = function (e) {
      e.preventDefault(); // Varsayılan davranışı engelle
      var scrollOptions = {
        top: 0,
        behavior: "smooth",
      };

      // Sayfa yüksekliğini kontrol et ve scroll işlemini gerçekleştir
      if (document.documentElement.scrollHeight > window.innerHeight) {
        window.scrollTo(scrollOptions);
      }
    };
  </script>
</asp:Content>
