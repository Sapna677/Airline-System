document.addEventListener('DOMContentLoaded', () => {
    // 1. Theme Toggle Logic
    const savedTheme = localStorage.getItem('theme') || 'dark';
    if (savedTheme === 'light') {
        document.body.classList.add('light-theme');
    }

    // Create floating theme toggle button
    const toggleBtn = document.createElement('button');
    toggleBtn.id = 'theme-toggle-btn';
    toggleBtn.innerHTML = savedTheme === 'light' ? '<i class="fas fa-moon"></i>' : '<i class="fas fa-sun"></i>';
    toggleBtn.title = 'Switch Theme';
    
    // Style the toggle button dynamically
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

    // Hover effects
    toggleBtn.addEventListener('mouseenter', () => {
        toggleBtn.style.transform = 'scale(1.1) translateY(-3px)';
        toggleBtn.style.boxShadow = '0 12px 35px rgba(99, 102, 241, 0.45)';
    });
    toggleBtn.addEventListener('mouseleave', () => {
        toggleBtn.style.transform = 'scale(1) translateY(0)';
        toggleBtn.style.boxShadow = '0 8px 30px rgba(0, 0, 0, 0.35)';
    });

    // Toggle action
    toggleBtn.addEventListener('click', () => {
        const isLight = document.body.classList.toggle('light-theme');
        localStorage.setItem('theme', isLight ? 'light' : 'dark');
        toggleBtn.innerHTML = isLight ? '<i class="fas fa-moon"></i>' : '<i class="fas fa-sun"></i>';
        
        // Minor click scale bump animation
        toggleBtn.style.transform = 'scale(0.9)';
        setTimeout(() => {
            toggleBtn.style.transform = 'scale(1)';
        }, 100);
    });

    document.body.appendChild(toggleBtn);

    // 2. Dynamic Branding: SkyGlide Airways
    const logoDiv = document.querySelector('nav .logo');
    if (logoDiv && !logoDiv.querySelector('.logo-text')) {
        // Wrap logo in a flex container for alignment
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

    // 3. Scroll-to-Hide Navigation Bar Logic
    let lastScrollY = window.scrollY;
    window.addEventListener('scroll', () => {
        const nav = document.querySelector('nav');
        if (nav && window.innerWidth > 600) {
            if (nav.classList.contains('nav-open')) return;
            if (window.scrollY > lastScrollY && window.scrollY > 80) {
                nav.classList.add('nav-hidden');
            } else {
                nav.classList.remove('nav-hidden');
            }
        }
        lastScrollY = window.scrollY;
    });

    // 4. Mobile Navigation Menu Toggle
    const navElement = document.querySelector('nav');
    if (navElement) {
        // Create hamburger button
        const navToggle = document.createElement('button');
        navToggle.className = 'nav-toggle';
        navToggle.id = 'mobile-nav-toggle';
        navToggle.innerHTML = '<i class="fas fa-bars"></i>';
        navToggle.setAttribute('aria-label', 'Toggle Navigation Menu');
        
        // Append to nav
        navElement.appendChild(navToggle);
        
        // Toggle class on click
        navToggle.addEventListener('click', (e) => {
            e.stopPropagation();
            navElement.classList.toggle('nav-open');
            const isOpen = navElement.classList.contains('nav-open');
            navToggle.innerHTML = isOpen ? '<i class="fas fa-times"></i>' : '<i class="fas fa-bars"></i>';
        });
        
        // Close menu if clicking outside
        document.addEventListener('click', (e) => {
            if (navElement.classList.contains('nav-open') && !navElement.contains(e.target)) {
                navElement.classList.remove('nav-open');
                navToggle.innerHTML = '<i class="fas fa-bars"></i>';
            }
        });
    }

    // 5. Global Customer Support Chatbot Widget
    const botContainer = document.createElement('div');
    botContainer.id = 'skyglide-chatbot-container';
    botContainer.style.cssText = `
        position: fixed;
        bottom: 90px;
        right: 25px;
        z-index: 99999;
        font-family: 'Outfit', sans-serif;
    `;

    // Chat Trigger Bubble
    const botBubble = document.createElement('button');
    botBubble.id = 'chatbot-trigger-bubble';
    botBubble.title = 'SkyGlide Helper Bot';
    botBubble.innerHTML = '<i class="fas fa-comments"></i>';
    botBubble.style.cssText = `
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background: linear-gradient(135deg, #10b981, #059669);
        color: white;
        border: 2px solid rgba(255, 255, 255, 0.25);
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.3rem;
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.35);
        transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    `;

    // Hover animation for bubble
    botBubble.addEventListener('mouseenter', () => {
        botBubble.style.transform = 'scale(1.1) translateY(-3px)';
        botBubble.style.boxShadow = '0 12px 35px rgba(16, 185, 129, 0.45)';
    });
    botBubble.addEventListener('mouseleave', () => {
        botBubble.style.transform = 'scale(1) translateY(0)';
        botBubble.style.boxShadow = '0 8px 30px rgba(0, 0, 0, 0.35)';
    });

    // Chat Window
    const botWindow = document.createElement('div');
    botWindow.id = 'chatbot-window';
    botWindow.style.cssText = `
        display: none;
        width: 320px;
        height: 400px;
        background: rgba(15, 23, 42, 0.95);
        backdrop-filter: blur(15px);
        -webkit-backdrop-filter: blur(15px);
        border: 1px solid rgba(255, 255, 255, 0.08);
        border-radius: 16px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.6);
        position: absolute;
        bottom: 60px;
        right: 0;
        flex-direction: column;
        overflow: hidden;
        animation: slideDown 0.3s cubic-bezier(0.4, 0, 0.2, 1) forwards;
    `;

    // Header
    const botHeader = document.createElement('div');
    botHeader.style.cssText = `
        background: linear-gradient(135deg, #6366f1, #4f46e5);
        color: white;
        padding: 12px 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-weight: 700;
        font-size: 0.95rem;
    `;
    botHeader.innerHTML = `
        <span><i class="fas fa-robot" style="margin-right: 6px;"></i> SkyGlide Assistant</span>
        <button id="chatbot-close-btn" style="background:none; border:none; color:white; font-size:1rem; cursor:pointer;"><i class="fas fa-times"></i></button>
    `;

    // Messages Area
    const botMessages = document.createElement('div');
    botMessages.style.cssText = `
        flex: 1;
        padding: 15px;
        overflow-y: auto;
        display: flex;
        flex-direction: column;
        gap: 12px;
        font-size: 0.85rem;
        color: #e2e8f0;
    `;

    // Input Area
    const botInputArea = document.createElement('div');
    botInputArea.style.cssText = `
        border-top: 1px solid rgba(255, 255, 255, 0.06);
        padding: 10px;
        display: flex;
        gap: 8px;
        background: rgba(0, 0, 0, 0.2);
    `;
    botInputArea.innerHTML = `
        <input type="text" id="chatbot-user-input" placeholder="Type your question..." style="flex:1; background:rgba(255,255,255,0.05); border:1px solid rgba(255,255,255,0.1); border-radius:8px; color:white; padding:8px 12px; font-size:0.8rem; outline:none;">
        <button id="chatbot-send-btn" style="background:#6366f1; border:none; border-radius:8px; color:white; width:34px; height:34px; cursor:pointer; display:flex; align-items:center; justify-content:center;"><i class="fas fa-paper-plane"></i></button>
    `;

    // Append child elements
    botWindow.appendChild(botHeader);
    botWindow.appendChild(botMessages);
    botWindow.appendChild(botInputArea);

    botContainer.appendChild(botBubble);
    botContainer.appendChild(botWindow);
    document.body.appendChild(botContainer);

    // Initial bot responses
    const botFaqs = {
        "how to book": "To book a ticket: Go to the home page, enter departure and arrival details with date, search flights, select your passenger seat, make payment, and download your boarding pass!",
        "baggage policy": "Check-in Baggage allowance is: Economy: 15kg, Business: 25kg, First: 35kg. Excess check-in baggage is charged starting at INR 450 per kg.",
        "cancellation": "You can cancel any booking on the Profile page. Under Booking History, click 'Cancel Booking'. Refunds are processed within 3-5 business days.",
        "reprint pass": "Go to your Profile page booking history, find your paid flight, and click the 'Boarding Pass' button to print it anytime.",
        "support contact": "Call us at +91 6205709663 or email at Skyglide121@gmail.com for immediate escalations."
    };

    function appendMessage(text, isUser = false) {
        const msg = document.createElement('div');
        msg.style.cssText = `
            max-width: 80%;
            padding: 8px 12px;
            border-radius: 12px;
            line-height: 1.4;
            word-wrap: break-word;
            ${isUser ? 'align-self: flex-end; background:#6366f1; color:white;' : 'align-self: flex-start; background:rgba(255,255,255,0.06); border:1px solid rgba(255,255,255,0.05); color:#f1f5f9;'}
        `;
        msg.textContent = text;
        botMessages.appendChild(msg);
        botMessages.scrollTop = botMessages.scrollHeight;
    }

    function appendFaqButtons() {
        const faqPillContainer = document.createElement('div');
        faqPillContainer.className = 'faq-pill-container';
        faqPillContainer.style.cssText = 'display:flex; flex-direction:column; gap:6px; align-self:flex-start; width:100%; margin-top:5px;';
        
        const faqs = [
            { text: "How do I book a ticket?", key: "how to book" },
            { text: "What is the Baggage Policy?", key: "baggage policy" },
            { text: "How to cancel a booking?", key: "cancellation" },
            { text: "How to reprint boarding pass?", key: "reprint pass" }
        ];

        faqs.forEach(faq => {
            const btn = document.createElement('button');
            btn.textContent = faq.text;
            btn.style.cssText = `
                text-align:left; background:rgba(99,102,241,0.08); border:1px solid rgba(99,102,241,0.25); border-radius:8px; padding:6px 10px; font-size:0.75rem; color:#a5b4fc; cursor:pointer; width:fit-content; transition:all 0.2s ease;
            `;
            btn.addEventListener('mouseenter', () => btn.style.background = 'rgba(99,102,241,0.15)');
            btn.addEventListener('mouseleave', () => btn.style.background = 'rgba(99,102,241,0.08)');
            btn.addEventListener('click', () => {
                appendMessage(faq.text, true);
                faqPillContainer.remove();
                simulateTypingAndReply(botFaqs[faq.key]);
            });
            faqPillContainer.appendChild(btn);
        });
        botMessages.appendChild(faqPillContainer);
        botMessages.scrollTop = botMessages.scrollHeight;
    }

    function simulateTypingAndReply(replyText) {
        // Typing indicator
        const typing = document.createElement('div');
        typing.textContent = "SkyGlide bot is typing...";
        typing.style.cssText = 'align-self:flex-start; color:#6b7280; font-style:italic; font-size:0.75rem;';
        botMessages.appendChild(typing);
        botMessages.scrollTop = botMessages.scrollHeight;

        setTimeout(() => {
            typing.remove();
            appendMessage(replyText, false);
            // Append FAQ pills again to keep options active
            appendFaqButtons();
        }, 800);
    }

    // Toggle Chat Window
    botBubble.addEventListener('click', (e) => {
        e.stopPropagation();
        const isOpen = botWindow.style.display === 'flex';
        botWindow.style.display = isOpen ? 'none' : 'flex';
        
        if (!isOpen && botMessages.children.length === 0) {
            appendMessage("Hi there! Welcome to SkyGlide Airways Customer Support. How can I help you today?", false);
            appendFaqButtons();
        }
    });

    document.getElementById('chatbot-close-btn').addEventListener('click', () => {
        botWindow.style.display = 'none';
    });

    // Handle user keyboard/input submit
    const submitUserMessage = () => {
        const input = document.getElementById('chatbot-user-input');
        const text = input.value.trim();
        if (text) {
            appendMessage(text, true);
            input.value = '';
            
            // Search for matches in faqs
            let found = false;
            for (const key in botFaqs) {
                if (text.toLowerCase().includes(key) || key.includes(text.toLowerCase())) {
                    simulateTypingAndReply(botFaqs[key]);
                    found = true;
                    break;
                }
            }
            if (!found) {
                simulateTypingAndReply("I'm sorry, I didn't quite get that. Please try selecting one of our frequently asked questions below or contact our hotline.");
            }
        }
    };

    document.getElementById('chatbot-send-btn').addEventListener('click', submitUserMessage);
    document.getElementById('chatbot-user-input').addEventListener('keypress', (e) => {
        if (e.key === 'Enter') submitUserMessage();
    });

    // Close chatbot if clicking outside
    document.addEventListener('click', (e) => {
        if (botWindow.style.display === 'flex' && !botContainer.contains(e.target)) {
            botWindow.style.display = 'none';
        }
    });
});
