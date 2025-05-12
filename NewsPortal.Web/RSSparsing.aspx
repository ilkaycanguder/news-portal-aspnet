<%@ Page Title="RSS Haberler" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RSSparsing.aspx.cs" Inherits="NewsPortal.Web.RSSparsing" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />

    <div class="container" style="max-width: 1200px; margin-top: 48px;">
        <h2 class="mb-4 fw-semibold text-center" style="letter-spacing: 0.5px;">RSS Haberler</h2>
        <div class="row mb-4 justify-content-center">
            <div class="col-md-6 col-lg-4">
                <asp:DropDownList ID="ddlRSSFeeds" runat="server" CssClass="form-select form-select-lg mb-3" AutoPostBack="true"
                    OnSelectedIndexChanged="ddlRSSFeeds_SelectedIndexChanged">
                    <asp:ListItem Text="Seçiniz" Value="" Selected="True" />
                    <asp:ListItem Text="NTV Son Dakika" Value="https://www.ntv.com.tr/son-dakika.rss" />
                    <asp:ListItem Text="NTV Foto Galeri" Value="https://www.ntv.com.tr/galeri.rss" />
                    <asp:ListItem Text="NTV Video Galeri" Value="https://www.ntv.com.tr/video.rss" />
                    <asp:ListItem Text="NTV Gündem" Value="https://www.ntv.com.tr/gundem.rss" />
                    <asp:ListItem Text="NTV Türkiye" Value="https://www.ntv.com.tr/turkiye.rss" />
                    <asp:ListItem Text="NTV Eğitim" Value="https://www.ntv.com.tr/egitim.rss" />
                    <asp:ListItem Text="NTV Ekonomi" Value="https://www.ntv.com.tr/ekonomi.rss" />
                    <asp:ListItem Text="NTV Para" Value="https://www.ntv.com.tr/ntvpara.rss" />
                    <asp:ListItem Text="NTV N-Life" Value="https://www.ntv.com.tr/n-life.rss" />
                    <asp:ListItem Text="NTV Dünya" Value="https://www.ntv.com.tr/dunya.rss" />
                    <asp:ListItem Text="NTV Yaşam" Value="https://www.ntv.com.tr/yasam.rss" />
                    <asp:ListItem Text="NTV Spor" Value="https://www.ntv.com.tr/spor.rss" />
                    <asp:ListItem Text="NTV Spor & Skor" Value="https://www.ntv.com.tr/sporskor.rss" />
                    <asp:ListItem Text="NTV Teknoloji" Value="https://www.ntv.com.tr/teknoloji.rss" />
                    <asp:ListItem Text="NTV Sağlık" Value="https://www.ntv.com.tr/saglik.rss" />
                    <asp:ListItem Text="NTV Sanat" Value="https://www.ntv.com.tr/sanat.rss" />
                    <asp:ListItem Text="NTV Seyahat" Value="https://www.ntv.com.tr/seyahat.rss" />
                    <asp:ListItem Text="NTV Otomobil" Value="https://www.ntv.com.tr/otomobil.rss" />
                </asp:DropDownList>
            </div>
        </div>
        <div class="row g-4 news-grid justify-content-center">
            <asp:Repeater ID="rptNews" runat="server">
                <ItemTemplate>
                    <div class="col-lg-4 col-md-6 col-sm-12 d-flex align-items-stretch">
                        <div class="news-card card shadow-sm border-0 mb-4">
                            <div class="news-image-wrapper card-img-top p-0" style="background: #f5f5f5;">
                                <img src='<%# Eval("ImageUrl") %>' class="news-img rounded-top" alt='<%# Eval("Title") %>' onerror="this.src='Content/Images/default-news.jpg'">
                            </div>
                            <div class="news-content-wrapper card-body d-flex flex-column">
                                <h5 class="news-title card-title mb-2 text-dark fw-bold">
                                    <%# Eval("Title") %>

                                </h5>
                                <div class="news-meta mb-2 small text-muted d-flex align-items-center gap-2">
                                    <span class="badge bg-primary"><%# Eval("Category") %></span>
                                    <span class="news-author"><i class="fas fa-user"></i><%# Eval("Author") %></span>
                                    <span class="news-date"><i class="fas fa-calendar"></i><%# Eval("PubDate") %></span>
                                </div>
                                <p class="news-desc card-text mt-auto"><%# Eval("Description") %></p>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <div class="row mt-4">
            <div class="col-md-12 text-start">
                <asp:HyperLink ID="lnkGoBack" runat="server" NavigateUrl="~/Home.aspx" CssClass="btn btn-outline-secondary btn-sm" ToolTip="Ana Sayfa">
    <i class="fas fa-chevron-left"></i>
                </asp:HyperLink>
            </div>
        </div>
    </div>
    <style>
        body {
            background: #f8f9fa;
        }

        .news-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 2rem 1.5rem;
        }

        .news-card {
            border-radius: 18px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.08);
            background: #fff;
            transition: box-shadow 0.2s, transform 0.2s;
            min-height: 420px;
            display: flex;
            flex-direction: column;
        }

            .news-card:hover {
                box-shadow: 0 8px 32px rgba(0,0,0,0.13);
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

        .news-author, .news-date {
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

        @media (max-width: 992px) {
            .col-lg-4 {
                flex: 0 0 50%;
                max-width: 50%;
            }
        }

        @media (max-width: 768px) {
            .col-lg-4, .col-md-6 {
                flex: 0 0 100%;
                max-width: 100%;
            }

            .news-image-wrapper {
                height: 160px;
            }
        }

        .btn-outline-secondary {
            border-radius: 30px;
            padding: 0.45rem 1rem;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
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

    </style>
</asp:Content>
