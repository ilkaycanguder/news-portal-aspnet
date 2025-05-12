<%@ Page Title="Haber Detayı" Language="C#" MasterPageFile="~/Site.Master"
AutoEventWireup="true" CodeBehind="NewsDetail.aspx.cs"
Inherits="NewsPortal.Web.NewsDetail" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <asp:Panel ID="pnlNewsDetail" runat="server" CssClass="news-detail">
          <h1 class="news-title">
            <asp:Label ID="lblTitle" runat="server" />
          </h1>

          <div class="news-meta">
            <span class="category">
              <i class="fas fa-folder"></i>
              <asp:Label ID="lblCategory" runat="server" />
            </span>
            <span class="author">
              <i class="fas fa-user"></i>
              <asp:Label ID="lblAuthor" runat="server" />
            </span>
            <span class="date">
              <i class="fas fa-calendar"></i>
              <asp:Label ID="lblPubDate" runat="server" />
            </span>
          </div>

          <div class="news-image">
            <asp:Image ID="imgNews" runat="server" CssClass="img-fluid" />
          </div>

          <div class="news-content">
            <asp:Literal ID="ltlDescription" runat="server" />
          </div>

          <div class="news-actions mt-4">
            <asp:HyperLink
              ID="lnkBack"
              runat="server"
              NavigateUrl="~/Home.aspx"
              CssClass="btn btn-primary"
            >
              <i class="fas fa-arrow-left"></i> Ana Sayfaya Dön
            </asp:HyperLink>
          </div>
        </asp:Panel>

        <asp:Panel
          ID="pnlError"
          runat="server"
          CssClass="alert alert-danger"
          Visible="false"
        >
          Haber bulunamadı veya bir hata oluştu.
        </asp:Panel>
      </div>
    </div>
  </div>

  <style>
    .news-detail {
      padding: 2.5rem 0;
      background-color: #fdfdfd;
    }

    .news-title {
      font-size: 2.2rem;
      font-weight: 700;
      margin-bottom: 1.2rem;
      color: #222;
      line-height: 1.3;
    }

    .news-meta {
      display: flex;
      flex-wrap: wrap;
      align-items: center;
      gap: 1rem;
      margin-bottom: 2rem;
      font-size: 0.95rem;
      color: #777;
    }

    .news-meta span i {
      margin-right: 6px;
      color: #007bff;
    }

    .news-image {
      margin-bottom: 2rem;
      text-align: center;
    }

    .news-image img {
      max-width: 100%;
      height: auto;
      border-radius: 12px;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
    }

    .news-content {
      font-size: 1.1rem;
      line-height: 1.9;
      color: #444;
      text-align: justify;
      word-break: break-word;
    }

    .news-actions {
      margin-top: 2.5rem;
      display: flex;
      justify-content: flex-start;
    }

    .btn-primary {
      font-size: 1rem;
      padding: 0.6rem 1.2rem;
      border-radius: 6px;
      background-color: #007bff;
      border: none;
      transition: background-color 0.2s ease;
    }

    .btn-primary:hover {
      background-color: #0056b3;
      text-decoration: none;
    }

    @media (max-width: 768px) {
      .news-title {
        font-size: 1.8rem;
      }

      .news-meta {
        font-size: 0.9rem;
        flex-direction: column;
        align-items: flex-start;
      }

      .news-actions {
        justify-content: center;
      }
    }
  </style>
</asp:Content>
