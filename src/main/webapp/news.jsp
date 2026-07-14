<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>News & Announcements | SkyGlide Airways</title>
    <!-- FontAwesome & Style Sheets -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer">
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        .news-header {
            margin-bottom: 40px;
            text-align: center;
        }
        
        .news-header p {
            font-size: 1.1rem;
            color: var(--text-secondary);
            max-width: 700px;
            margin: 15px auto 0;
            line-height: 1.6;
        }

        .filter-panel {
            background: rgba(15, 23, 42, 0.4);
            border: 1px solid var(--card-border);
            border-radius: var(--border-radius-md);
            padding: 20px;
            margin-bottom: 30px;
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: center;
            justify-content: space-between;
            backdrop-filter: blur(8px);
        }

        .search-box-wrapper {
            position: relative;
            flex: 1;
            min-width: 280px;
        }

        .search-box-wrapper i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            font-size: 1rem;
        }

        .search-box-wrapper input {
            width: 100%;
            padding: 12px 16px 12px 45px;
            background: var(--input-bg);
            border: 1px solid var(--input-border);
            border-radius: var(--border-radius-md);
            color: white;
            font-size: 0.95rem;
            transition: var(--transition-smooth);
        }

        .search-box-wrapper input:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px var(--input-focus);
            background: rgba(255, 255, 255, 0.08);
        }

        .filter-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn-filter {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--input-border);
            color: var(--text-secondary);
            padding: 10px 18px;
            border-radius: var(--border-radius-md);
            cursor: pointer;
            font-weight: 500;
            font-size: 0.9rem;
            transition: var(--transition-smooth);
        }

        .btn-filter:hover, .btn-filter.active {
            background: var(--accent-gradient);
            color: white;
            border-color: transparent;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
        }

        /* News Cards Grid */
        .news-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }

        .news-card {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: var(--border-radius-lg);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: var(--transition-smooth);
            backdrop-filter: blur(16px);
            opacity: 0;
            transform: translateY(20px);
            animation: cardFadeIn 0.6s cubic-bezier(0.4, 0, 0.2, 1) forwards;
        }

        @keyframes cardFadeIn {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .news-card:hover {
            transform: translateY(-5px);
            border-color: rgba(99, 102, 241, 0.3);
            box-shadow: 0 15px 35px -10px rgba(99, 102, 241, 0.15), var(--shadow-premium);
        }

        .news-img {
            width: 100%;
            height: 180px;
            background-size: cover;
            background-position: center;
            border-bottom: 1px solid var(--card-border);
        }

        .news-content {
            padding: 25px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .news-meta {
            display: flex;
            justify-content: space-between;
            font-size: 0.8rem;
            color: var(--text-secondary);
            margin-bottom: 12px;
        }

        .news-category-tag {
            color: #a5b4fc;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .news-title {
            color: white;
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 10px;
            line-height: 1.4;
        }

        .news-excerpt {
            color: var(--text-secondary);
            font-size: 0.95rem;
            line-height: 1.5;
            margin-bottom: 20px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .btn-read-more {
            background: transparent;
            border: 1px solid var(--input-border);
            color: white;
            padding: 10px 15px;
            border-radius: var(--border-radius-md);
            font-weight: 600;
            font-size: 0.85rem;
            cursor: pointer;
            transition: var(--transition-smooth);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: fit-content;
        }

        .btn-read-more:hover {
            background: var(--accent-gradient);
            border-color: transparent;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
        }

        /* News Modal Overlay */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(11, 15, 25, 0.8);
            backdrop-filter: blur(12px);
            z-index: 2000;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.4s ease;
        }

        .modal-overlay.active {
            opacity: 1;
            pointer-events: auto;
        }

        .modal-container {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: var(--border-radius-lg);
            width: 90%;
            max-width: 700px;
            max-height: 85vh;
            overflow-y: auto;
            padding: 35px;
            box-shadow: var(--shadow-premium);
            transform: translateY(30px) scale(0.95);
            transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .modal-overlay.active .modal-container {
            transform: translateY(0) scale(1);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 1px solid var(--card-border);
            padding-bottom: 15px;
        }

        .modal-header h3 {
            font-size: 1.5rem;
            font-weight: 700;
            color: white;
            line-height: 1.4;
        }

        .btn-modal-close {
            background: transparent;
            border: none;
            color: var(--text-secondary);
            font-size: 1.6rem;
            cursor: pointer;
            transition: var(--transition-smooth);
        }

        .btn-modal-close:hover {
            color: white;
            transform: scale(1.1);
        }

        .modal-body {
            color: var(--text-secondary);
            font-size: 1.05rem;
            line-height: 1.7;
        }

        .modal-news-meta {
            display: flex;
            gap: 20px;
            font-size: 0.85rem;
            color: var(--text-secondary);
            margin-bottom: 20px;
            border-bottom: 1px solid var(--card-border);
            padding-bottom: 15px;
        }

        .modal-news-img {
            width: 100%;
            height: 300px;
            border-radius: var(--border-radius-md);
            background-size: cover;
            background-position: center;
            margin-bottom: 25px;
        }

        /* Light theme adjustments */
        body.light-theme .filter-panel {
            background: rgba(255, 255, 255, 0.6);
            border-color: rgba(0, 0, 0, 0.08);
        }

        body.light-theme .search-box-wrapper input {
            color: #1e293b;
            background: rgba(0, 0, 0, 0.03);
            border-color: rgba(0, 0, 0, 0.1);
        }
        
        body.light-theme .search-box-wrapper input:focus {
            background: white;
            border-color: #6366f1;
        }

        body.light-theme .btn-filter {
            background: rgba(0, 0, 0, 0.03);
            border-color: rgba(0, 0, 0, 0.1);
            color: #475569;
        }

        body.light-theme .btn-filter:hover, body.light-theme .btn-filter.active {
            color: white;
            border-color: transparent;
        }

        body.light-theme .news-title,
        body.light-theme .modal-header h3 {
            color: #0f172a;
        }

        body.light-theme .news-category-tag {
            color: #4f46e5;
        }

        body.light-theme .btn-read-more {
            color: #475569;
            border-color: rgba(0, 0, 0, 0.1);
        }

        body.light-theme .btn-read-more:hover {
            color: white;
            border-color: transparent;
        }

        body.light-theme .modal-overlay {
            background: rgba(255, 255, 255, 0.5);
        }

        .no-news-found {
            text-align: center;
            padding: 50px 20px;
            color: var(--text-secondary);
            font-size: 1.2rem;
            display: none;
            flex-direction: column;
            align-items: center;
            gap: 15px;
            width: 100%;
        }

        .no-news-found i {
            font-size: 3rem;
            color: var(--text-secondary);
            opacity: 0.6;
        }
    </style>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            // Theme toggle script injection
            if (!document.querySelector('link[href*="font-awesome"]') && !document.querySelector('link[href*="all.min.css"]')) {
                const faLink = document.createElement('link');
                faLink.rel = 'stylesheet';
                faLink.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css';
                document.head.appendChild(faLink);
            }

            const savedTheme = localStorage.getItem('theme') || 'dark';
            if (savedTheme === 'light') {
                document.body.classList.add('light-theme');
            }

            const toggleBtn = document.createElement('button');
            toggleBtn.id = 'theme-toggle-btn';
            toggleBtn.innerHTML = savedTheme === 'light' ? '<i class="fas fa-moon"></i>' : '<i class="fas fa-sun"></i>';
            toggleBtn.title = 'Switch Theme';
            
            toggleBtn.style.cssText = `
                position: fixed;
                bottom: 25px;
                right: 25px;
                width: 50px;
                height: 50px;
                border-radius: 50%;
                background: linear-gradient(135deg, #6366f1, #4f46e5);
                color: white;
                border: 2px solid rgba(255, 255, 255, 0.25);
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.3rem;
                box-shadow: 0 8px 30px rgba(0, 0, 0, 0.35);
                z-index: 99999;
                transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            `;

            toggleBtn.addEventListener('mouseenter', () => {
                toggleBtn.style.transform = 'scale(1.1) translateY(-3px)';
                toggleBtn.style.boxShadow = '0 12px 35px rgba(99, 102, 241, 0.45)';
            });
            toggleBtn.addEventListener('mouseleave', () => {
                toggleBtn.style.transform = 'scale(1) translateY(0)';
                toggleBtn.style.boxShadow = '0 8px 30px rgba(0, 0, 0, 0.35)';
            });

            toggleBtn.addEventListener('click', () => {
                const isLight = document.body.classList.toggle('light-theme');
                localStorage.setItem('theme', isLight ? 'light' : 'dark');
                toggleBtn.innerHTML = isLight ? '<i class="fas fa-moon"></i>' : '<i class="fas fa-sun"></i>';
                toggleBtn.style.transform = 'scale(0.9)';
                setTimeout(() => {
                    toggleBtn.style.transform = 'scale(1)';
                }, 100);
            });

            document.body.appendChild(toggleBtn);

            // Dynamic Branding: SkyGlide Airways
            const logoDiv = document.querySelector('nav .logo');
            if (logoDiv && !logoDiv.querySelector('.logo-text')) {
                logoDiv.style.display = 'flex';
                logoDiv.style.alignItems = 'center';
                logoDiv.style.gap = '10px';

                const logoText = document.createElement('span');
                logoText.className = 'logo-text';
                logoText.innerHTML = 'SkyGlide <span style="font-weight: 400; font-size: 0.85rem; letter-spacing: 2px; opacity: 0.8; color: #ff9900;">AIRWAYS</span>';
                logoText.style.cssText = `
                    font-weight: 800;
                    font-size: 1.4rem;
                    color: var(--text-primary);
                    letter-spacing: 1px;
                    font-family: 'Outfit', sans-serif;
                    transition: var(--transition-smooth);
                `;
                logoDiv.appendChild(logoText);
            }
        });
    </script>
<script src="js/theme.js"></script>
</head>
<body>
    <!-- Background overlay -->
    <div style="position: fixed; top: 0; left: 0; min-width: 100%; min-height: 100%; z-index: -2; background: url('al2.jpg') no-repeat center fixed; background-size: cover;"></div>
    <div class="bg-overlay" style="position: fixed; top: 0; left: 0; min-width: 100%; min-height: 100%; z-index: -1; background: rgba(15, 23, 42, 0.85); backdrop-filter: blur(2px);"></div>

    <!-- Header Navigation -->
    <nav>
        <div class="logo">
            <img alt="Airline Logo" src="download.png">
        </div>
        <ul>
            <li><a href="index.jsp">Home</a></li>
            <li><a href="searchFlights.jsp">Search Flights</a></li>
            <li><a href="flightStatus.jsp">Flight Status</a></li>
            <li><a href="contact.jsp">Contact</a></li>
            <li><a href="about.jsp">About</a></li>
        </ul>
    </nav>

    <!-- Page Container -->
    <div class="page-container">
        <main class="standalone-container" style="max-width: 1100px; margin-top: 40px; margin-bottom: 40px;">
            <div class="news-header">
                <h2>SkyGlide Newsroom</h2>
                <p>Stay up to date with the latest press releases, corporate flight news, fleet announcements, and travel guidelines from our executive team.</p>
            </div>

            <!-- Search and Filter Bar -->
            <div class="filter-panel">
                <div class="search-box-wrapper">
                    <i class="fas fa-search"></i>
                    <input type="text" id="newsSearchInput" placeholder="Search articles or announcements...">
                </div>
                <div class="filter-buttons">
                    <button class="btn-filter active" data-category="all">All News</button>
                    <button class="btn-filter" data-category="Announcements">Announcements</button>
                    <button class="btn-filter" data-category="Routes">New Routes</button>
                    <button class="btn-filter" data-category="Fleet">Fleet & Aviation</button>
                </div>
            </div>

            <!-- News Grid -->
            <div class="news-grid" id="newsGrid">
                <!-- Articles dynamically populated by JS -->
            </div>

            <!-- No News Found -->
            <div class="no-news-found" id="noNewsFound">
                <i class="fas fa-newspaper"></i>
                <p>No articles match your search or department filter.</p>
                <button class="btn-filter" id="resetNewsFilters" style="margin-top: 10px;">Clear Filters</button>
            </div>
        </main>

        <!-- Footer -->
        <footer>
            <div class="footer-content">
                <div class="footer-section">
                    <h3>About Us</h3>
                    <ul>
                        <li><a href="about.jsp"><i class="fas fa-info-circle"></i> Company Info</a></li>
                        <li><a href="careers.jsp"><i class="fas fa-briefcase"></i> Careers</a></li>
                        <li><a href="news.jsp"><i class="fas fa-newspaper"></i> News</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Contact Us</h3>
                    <ul>
                        <li><a href="contact.jsp"><i class="fas fa-phone-alt"></i> Customer Service</a></li>
                        <li><a href="feedback.jsp"><i class="fas fa-comments"></i> Feedback</a></li>
                        <li><a href="support.jsp"><i class="fas fa-life-ring"></i> Support</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Help</h3>
                    <ul>
                        <li><a href="faq.jsp"><i class="fas fa-question-circle"></i> FAQ</a></li>
                        <li><a href="policies.jsp"><i class="fas fa-file-alt"></i> Policies</a></li>
                        <li><a href="terms.jsp"><i class="fas fa-file-contract"></i> Terms of Service</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Follow Us</h3>
                    <ul>
                        <li><a href="https://www.facebook.com/"><i class="fab fa-facebook"></i> Facebook</a></li>
                        <li><a href="https://www.twitter.com/"><i class="fab fa-twitter"></i> Twitter</a></li>
                        <li><a href="https://www.instagram.com/_moodie.____"><i class="fab fa-instagram"></i> Instagram</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2026 SkyGlide Airways. All rights reserved.</p>
            </div>
        </footer>
    </div>

    <!-- Article Detail Modal -->
    <div class="modal-overlay" id="newsModalOverlay">
        <div class="modal-container">
            <div class="modal-header">
                <h3 id="modalArticleTitle">Article Title</h3>
                <button class="btn-modal-close" id="newsModalCloseBtn">&times;</button>
            </div>
            <div class="modal-news-meta">
                <span id="modalArticleCategory" style="color: #a5b4fc; font-weight: 600;">CATEGORY</span>
                <span id="modalArticleDate" style="color: var(--text-secondary);"><i class="fas fa-calendar-alt"></i> Date</span>
            </div>
            <div class="modal-news-img" id="modalArticleImg"></div>
            <div class="modal-body" id="modalArticleBody">
                <!-- Body populated dynamically -->
            </div>
        </div>
    </div>

    <script>
        const articles = [
            {
                id: 1,
                title: "SkyGlide Airways Announces Fleet Expansion with 12 New Airbus A321neo",
                category: "Fleet",
                date: "July 12, 2026",
                excerpt: "In a move to double our domestic capacity and enhance fuel efficiency, SkyGlide has signed an agreement to acquire twelve fuel-efficient A321neo aircraft delivery starting Q4.",
                body: `<p>SkyGlide Airways has officially announced the expansion of its narrow-body fleet with a firm order of twelve brand-new Airbus A321neo aircraft. This capital investment aligns with the airline's long-term sustainability goals and operational growth strategies.</p>
                       <p>The A321neo aircraft deliver superior fuel efficiency, cutting emissions by up to 20% compared to previous generation aircraft. Additionally, they provide passengers with wider seats, larger overhead bins, and a quieter cabin environment.</p>
                       <p>“This fleet enhancement represents a pivotal milestone for SkyGlide. It allows us to strengthen our connectivity between primary metros and tier-2 hubs while maintaining competitive ticket pricing for our loyal passengers,” stated our Chief Executive Officer.</p>`,
                image: "destination6.jpg"
            },
            {
                id: 2,
                title: "Direct Flights Launched Connecting Delhi and Male (Maldives)",
                category: "Routes",
                date: "June 28, 2026",
                excerpt: "Get ready to escape to paradise! Starting next month, SkyGlide starts operating non-stop daily flights linking New Delhi's IGI Airport with Male, Maldivian Capital.",
                body: `<p>SkyGlide Airways is thrilled to announce its newest international route connecting New Delhi (DEL) to Male, Maldives (MLE). Flights are scheduled to operate daily on our modern A320neo fleet, bringing convenient travel times for tourists and beachgoers alike.</p>
                       <p>To celebrate the launch, special promotional introductory fares starting from ₹11,999 one-way have been released. In-flight packages will include gourmet meals tailored for vacationers and excess beach baggage allowances.</p>
                       <p>Tickets are now open for sale through our passenger booking portal at SkyGlide.com or through accredited travel agencies.</p>`,
                image: "destination3.jpg"
            },
            {
                id: 3,
                title: "Enhanced Safety Protocols & CAR Compliance Regulations",
                category: "Announcements",
                date: "May 15, 2026",
                excerpt: "SkyGlide Airways implements DGCA's updated safety checklists. Learn more about the enhanced maintenance audits and cabin disinfection processes here.",
                body: `<p>Passenger safety is our highest priority at SkyGlide. In strict compliance with the Directorate General of Civil Aviation's (DGCA) updated Civil Aviation Requirements (CAR), we have incorporated extra safety check audits across our entire fleet.</p>
                       <p>Our aircraft now undergo deep, high-grade electro-static sanitization processes between flights. Flight decks are equipped with the latest real-time weather analytics software to ensure pre-emptive navigation around volatile turbulence fields.</p>
                       <p>We thank our engineering crew and cabin safety teams for their relentless dedication to achieving zero incidents on SkyGlide services.</p>`,
                image: "plane.jpg"
            },
            {
                id: 4,
                title: "SkyGlide Voted 'Most Reliable Regional Carrier' of 2026",
                category: "Announcements",
                date: "April 02, 2026",
                excerpt: "With a 96.2% on-time performance rate, SkyGlide Airways was awarded the prestigious Regional Carrier Excellence Award at the annual Aviation Leaders Summit.",
                body: `<p>We are proud to share that SkyGlide Airways has been named India's 'Most Reliable Regional Carrier' at the Aviation Leaders Summit held in Mumbai.</p>
                       <p>The award celebrates airlines demonstrating top-tier customer satisfaction, baggage safety records, and on-time performance metrics. With a 96.2% on-time departure rate over the past year, SkyGlide has set new reliability standards.</p>
                       <p>“We dedicate this achievement to our ground crew, dispatch teams, and pilots who keep our schedules punctual every single day,” said our operations director.</p>`,
                image: "destination8.jpg"
            }
        ];

        function renderArticles() {
            const grid = document.getElementById('newsGrid');
            const searchVal = document.getElementById('newsSearchInput').value.toLowerCase();
            const activeFilter = document.querySelector('.btn-filter.active').getAttribute('data-category');
            
            grid.innerHTML = '';
            let count = 0;

            articles.forEach(article => {
                const matchesSearch = article.title.toLowerCase().includes(searchVal) || 
                                      article.excerpt.toLowerCase().includes(searchVal) ||
                                      article.body.toLowerCase().includes(searchVal);
                const matchesFilter = activeFilter === 'all' || article.category === activeFilter;

                if (matchesSearch && matchesFilter) {
                    count++;
                    const card = document.createElement('div');
                    card.className = 'news-card';
                    card.style.animationDelay = `${count * 0.1}s`;

                    card.innerHTML = `
                        <div class="news-img" style="background-image: url('\${article.image}')"></div>
                        <div class="news-content">
                            <div>
                                <div class="news-meta">
                                    <span class="news-category-tag">\${article.category}</span>
                                    <span><i class="fas fa-calendar-alt"></i> \${article.date}</span>
                                </div>
                                <h4 class="news-title">\${article.title}</h4>
                                <p class="news-excerpt">\${article.excerpt}</p>
                            </div>
                            <button class="btn-read-more" onclick="openNewsModal(\${article.id})">
                                Read Full Article <i class="fas fa-arrow-right"></i>
                            </button>
                        </div>
                    `;
                    grid.appendChild(card);
                }
            });

            const noNews = document.getElementById('noNewsFound');
            if (count === 0) {
                noNews.style.display = 'flex';
                grid.style.display = 'none';
            } else {
                noNews.style.display = 'none';
                grid.style.display = 'grid';
            }
        }

        const modalOverlay = document.getElementById('newsModalOverlay');

        function openNewsModal(articleId) {
            const article = articles.find(a => a.id === articleId);
            if (!article) return;

            document.getElementById('modalArticleTitle').innerText = article.title;
            document.getElementById('modalArticleCategory').innerText = article.category;
            document.getElementById('modalArticleDate').innerHTML = `<i class="fas fa-calendar-alt"></i> \${article.date}`;
            document.getElementById('modalArticleImg').style.backgroundImage = `url('\${article.image}')`;
            document.getElementById('modalArticleBody').innerHTML = article.body;

            modalOverlay.classList.add('active');
        }

        function closeNewsModal() {
            modalOverlay.classList.remove('active');
        }

        // Event Listeners
        document.getElementById('newsSearchInput').addEventListener('input', renderArticles);

        document.querySelectorAll('.btn-filter').forEach(btn => {
            btn.addEventListener('click', (e) => {
                if (e.target.id === 'resetNewsFilters') return;
                document.querySelectorAll('.btn-filter').forEach(b => b.classList.remove('active'));
                e.target.classList.add('active');
                renderArticles();
            });
        });

        document.getElementById('resetNewsFilters').addEventListener('click', () => {
            document.getElementById('newsSearchInput').value = '';
            document.querySelectorAll('.btn-filter').forEach(b => b.classList.remove('active'));
            document.querySelector('.btn-filter[data-category="all"]').classList.add('active');
            renderArticles();
        });

        document.getElementById('newsModalCloseBtn').addEventListener('click', closeNewsModal);

        modalOverlay.addEventListener('click', (e) => {
            if (e.target === modalOverlay) {
                closeNewsModal();
            }
        });

        // Initialize News Feed
        renderArticles();
    </script>
</body>
</html>
