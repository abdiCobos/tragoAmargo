// Trago Amargo — Landing Page JS

const translations = {
  es: {
    nav_home: "Inicio",
    nav_features: "¿Qué hacemos?",
    nav_about: "Nosotros",
    nav_legal: "Aviso Legal",
    nav_enter: "Entrar",
    hero_badge: "☕ Comunidad cafetera",
    hero_title: "Muchas cafeterías,<br><span class=\"hero__title--highlight\">poca calidad y sabor</span>",
    hero_subtitle: "Descubre, califica y comparte las cafeterías que realmente valen la pena. Porque el buen café merece ser encontrado.",
    hero_btn_explore: "Explorar cafeterías",
    hero_btn_more: "Conocer más",
    stat_1: "Calificaciones",
    stat_2: "Dimensiones",
    stat_3: "% Honestidad",
    feat_title: "¿Qué es Trago Amargo?",
    feat_subtitle: "Una plataforma donde la comunidad califica cafeterías con criterios reales, no solo estrellitas.",
    feat_1_title: "Calidad del grano",
    feat_1_desc: "Evalúa la frescura, origen y calidad del café que sirven. No todo café sabe igual y el grano lo dice todo.",
    feat_2_title: "Sabrozura",
    feat_2_desc: "¿Qué tan sabroso está el café? Califica el sabor real, no la decoración del lugar ni la marca.",
    feat_3_title: "Manejo del tostado",
    feat_3_desc: "El tostado lo cambia todo. Evalúa qué tan bien manejan los niveles: claro, medio y oscuro.",
    feat_4_title: "Servicio y ambiente",
    feat_4_desc: "Porque el mejor café en un mal ambiente no sabe igual. Califica atención, espacio y experiencia.",
    showcase_title: "Califica con criterio,<br>no con estrellitas",
    showcase_desc: "A diferencia de otras apps donde todo es \"4.5 estrellas\", en Trago Amargo evaluamos cuatro dimensiones reales. Así sabes exactamente qué esperar antes de ir.",
    showcase_li1: "Reseñas con puntuación por categoría",
    showcase_li2: "Fotos reales de la comunidad",
    showcase_li3: "Mapa con cafeterías verificadas",
    showcase_li4: "Dueños pueden reclamar su local",
    showcase_li5: "Reportes de calidad y spam",
    about_title: "Acerca de nosotros",
    about_p1: "<strong>Trago Amargo</strong> nace de una frustración compartida: apps donde cada cafetería tiene 4.8 estrellas y al llegar el café sabe mal rompiendo toda ilusión que tenías respecto al establecimiento y su café.",
    about_p2: "Somos un equipo pequeño de entusiastas del café que creen que la calidad debe medirse con honestidad. No aceptamos reseñas patrocinadas, no inflamos puntuaciones. Solo datos reales de personas reales.",
    about_p3: "Nuestra misión es simple: <strong>que encuentres la mejor taza de café de tu ciudad</strong>, respaldada por una comunidad que sabe distinguir un buen grano de uno mal tostado.",
    cta_title: "¿Listo para encontrar tu próxima cafetería favorita?",
    cta_subtitle: "Únete gratis. Sin reseñas falsas. Solo café de verdad.",
    cta_btn: "Entrar a Trago Amargo",
    legal_title: "Aviso legal y privacidad",
    legal_1_title: "1. Información que recopilamos",
    legal_1_p: "Para el funcionamiento de la plataforma, recopilamos únicamente:",
    legal_1_li1_str: "Correo electrónico:",
    legal_1_li1: "utilizado exclusivamente para autenticar tu cuenta y permitir el inicio de sesión.",
    legal_1_li2_str: "Nombre de usuario:",
    legal_1_li2: "el nombre que elijas para mostrar en tus reseñas y perfil público.",
    legal_1_li3_str: "Foto de perfil (opcional):",
    legal_1_li3: "puedes subir una imagen para personalizar tu cuenta.",
    legal_1_li4_str: "Reseñas y calificaciones:",
    legal_1_li4: "el contenido que publiques sobre cafeterías es público por naturaleza.",
    legal_2_title: "2. Uso de la información",
    legal_2_p: "Tu información personal <strong>nunca</strong> será vendida, compartida con terceros ni utilizada para fines publicitarios. El correo electrónico se usa exclusivamente para:",
    legal_2_li1: "Autenticación de cuenta (inicio de sesión)",
    legal_2_li2: "Recuperación de contraseña",
    legal_2_li3: "Notificaciones relacionadas con tu actividad (respuestas a reseñas, reclamaciones de cafeterías)",
    legal_3_title: "3. Contenido generado por usuarios",
    legal_3_p: "Las reseñas, fotos y calificaciones que publiques son visibles para otros usuarios de la plataforma. Eres responsable del contenido que compartes. Nos reservamos el derecho de eliminar contenido que infrinja nuestras normas comunitarias (spam, contenido ofensivo, información falsa).",
    legal_4_title: "4. Protección de datos",
    legal_4_p: "Utilizamos Firebase (Google Cloud Platform) para almacenar datos. Tus credenciales de acceso están protegidas mediante los estándares de seguridad de Firebase Authentication. No almacenamos contraseñas en texto plano.",
    legal_5_title: "5. Cookies y seguimiento",
    legal_5_p: "<strong>No utilizamos cookies de terceros ni sistemas de tracking.</strong> La plataforma solo utiliza las cookies técnicas necesarias para mantener tu sesión iniciada (Firebase Auth). No recolectamos datos de navegación ni perfilamos usuarios.",
    legal_6_title: "6. Eliminación de cuenta",
    legal_6_p: "Puedes solicitar la eliminación de tu cuenta y todos tus datos asociados en cualquier momento contactándonos. Una vez eliminada, tus reseñas se anonimizarán y tus datos personales serán borrados permanentemente.",
    legal_7_title: "7. Contacto",
    legal_7_p: "Para cualquier duda sobre este aviso legal o para ejercer tus derechos de acceso, rectificación o eliminación de datos, contáctanos a través de los canales disponibles en la plataforma.",
    legal_updated: "Última actualización: Junio 2026",
    footer_slogan: "Muchas cafeterías, poca calidad y sabor.",
    footer_app: "App",
    footer_copy: "&copy; 2026 Trago Amargo. Todos los derechos reservados."
  },
  en: {
    nav_home: "Home",
    nav_features: "What we do?",
    nav_about: "About Us",
    nav_legal: "Legal",
    nav_enter: "Enter",
    hero_badge: "☕ Coffee Community",
    hero_title: "Many coffee shops,<br><span class=\"hero__title--highlight\">poor quality & taste</span>",
    hero_subtitle: "Discover, rate and share the coffee shops that are truly worth it. Because good coffee deserves to be found.",
    hero_btn_explore: "Explore coffee shops",
    hero_btn_more: "Learn more",
    stat_1: "Reviews",
    stat_2: "Dimensions",
    stat_3: "% Honesty",
    feat_title: "What is Trago Amargo?",
    feat_subtitle: "A platform where the community rates coffee shops with real criteria, not just little stars.",
    feat_1_title: "Bean Quality",
    feat_1_desc: "Evaluate the freshness, origin, and quality of the coffee served. Not all coffee tastes the same and the bean says it all.",
    feat_2_title: "Tastiness",
    feat_2_desc: "How tasty is the coffee? Rate the real flavor, not the place's decoration or the brand.",
    feat_3_title: "Roast Handling",
    feat_3_desc: "The roast changes everything. Evaluate how well they handle the levels: light, medium, and dark.",
    feat_4_title: "Service & Vibe",
    feat_4_desc: "Because the best coffee in a bad environment doesn't taste the same. Rate service, space, and experience.",
    showcase_title: "Rate with criteria,<br>not with stars",
    showcase_desc: "Unlike other apps where everything is \"4.5 stars\", at Trago Amargo we evaluate four real dimensions. So you know exactly what to expect before going.",
    showcase_li1: "Reviews with scoring per category",
    showcase_li2: "Real photos from the community",
    showcase_li3: "Map with verified coffee shops",
    showcase_li4: "Owners can claim their local",
    showcase_li5: "Quality and spam reports",
    about_title: "About Us",
    about_p1: "<strong>Trago Amargo</strong> was born out of a shared frustration: apps where every coffee shop has 4.8 stars and upon arrival the coffee tastes bad, shattering all the illusion you had about the establishment and its coffee.",
    about_p2: "We are a small team of coffee enthusiasts who believe quality should be measured with honesty. We don't accept sponsored reviews, we don't inflate scores. Just real data from real people.",
    about_p3: "Our mission is simple: <strong>for you to find the best cup of coffee in your city</strong>, backed by a community that knows how to distinguish a good bean from a badly roasted one.",
    cta_title: "Ready to find your next favorite coffee shop?",
    cta_subtitle: "Join for free. No fake reviews. Just real coffee.",
    cta_btn: "Enter Trago Amargo",
    legal_title: "Legal Notice and Privacy",
    legal_1_title: "1. Information we collect",
    legal_1_p: "For the operation of the platform, we only collect:",
    legal_1_li1_str: "Email:",
    legal_1_li1: "used exclusively to authenticate your account and allow login.",
    legal_1_li2_str: "Username:",
    legal_1_li2: "the name you choose to display on your reviews and public profile.",
    legal_1_li3_str: "Profile picture (optional):",
    legal_1_li3: "you can upload an image to personalize your account.",
    legal_1_li4_str: "Reviews and ratings:",
    legal_1_li4: "the content you post about coffee shops is public by nature.",
    legal_2_title: "2. Use of information",
    legal_2_p: "Your personal information will <strong>never</strong> be sold, shared with third parties, or used for advertising purposes. The email is exclusively used for:",
    legal_2_li1: "Account authentication (login)",
    legal_2_li2: "Password recovery",
    legal_2_li3: "Notifications related to your activity (replies to reviews, coffee shop claims)",
    legal_3_title: "3. User-generated content",
    legal_3_p: "The reviews, photos, and ratings you post are visible to other users of the platform. You are responsible for the content you share. We reserve the right to remove content that violates our community guidelines (spam, offensive content, false information).",
    legal_4_title: "4. Data protection",
    legal_4_p: "We use Firebase (Google Cloud Platform) to store data. Your access credentials are protected using Firebase Authentication security standards. We do not store plaintext passwords.",
    legal_5_title: "5. Cookies and tracking",
    legal_5_p: "<strong>We do not use third-party cookies or tracking systems.</strong> The platform only uses the technical cookies necessary to keep your session logged in (Firebase Auth). We do not collect browsing data or profile users.",
    legal_6_title: "6. Account deletion",
    legal_6_p: "You can request the deletion of your account and all associated data at any time by contacting us. Once deleted, your reviews will be anonymized and your personal data will be permanently erased.",
    legal_7_title: "7. Contact",
    legal_7_p: "For any questions about this legal notice or to exercise your rights of access, rectification, or deletion of data, contact us through the channels available on the platform.",
    legal_updated: "Last updated: June 2026",
    footer_slogan: "Many coffee shops, poor quality & taste.",
    footer_app: "App",
    footer_copy: "&copy; 2026 Trago Amargo. All rights reserved."
  }
};

let currentLang = localStorage.getItem('trago_lang') || 'es';

document.addEventListener('DOMContentLoaded', () => {
  initScrollAnimations();
  initMobileMenu();
  initHeaderScroll();
  initCountAnimation();
  initLanguageToggle();
  applyTranslations();
});

function initLanguageToggle() {
  const btn = document.getElementById('lang-toggle');
  if (!btn) return;
  btn.textContent = currentLang === 'es' ? 'EN' : 'ES';
  btn.addEventListener('click', () => {
    currentLang = currentLang === 'es' ? 'en' : 'es';
    localStorage.setItem('trago_lang', currentLang);
    btn.textContent = currentLang === 'es' ? 'EN' : 'ES';
    applyTranslations();
  });
}

function applyTranslations() {
  const elements = document.querySelectorAll('[data-i18n]');
  const dict = translations[currentLang];
  elements.forEach(el => {
    const key = el.getAttribute('data-i18n');
    if (dict[key]) {
      el.innerHTML = dict[key];
    }
  });
  document.documentElement.lang = currentLang;
}

/* ---- Scroll-triggered fade-in ---- */
function initScrollAnimations() {
  const elements = document.querySelectorAll('.fade-in');
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
      }
    });
  }, { threshold: 0.15, rootMargin: '0px 0px -40px 0px' });
  elements.forEach(el => observer.observe(el));
}

/* ---- Mobile menu ---- */
function initMobileMenu() {
  const toggle = document.getElementById('nav-toggle');
  const menu = document.getElementById('nav-menu');
  if (!toggle || !menu) return;
  toggle.addEventListener('click', () => menu.classList.toggle('open'));
  menu.querySelectorAll('.nav__link').forEach(link => {
    link.addEventListener('click', () => menu.classList.remove('open'));
  });
}

/* ---- Header shadow on scroll ---- */
function initHeaderScroll() {
  const header = document.getElementById('header');
  if (!header) return;
  window.addEventListener('scroll', () => {
    header.classList.toggle('scrolled', window.scrollY > 10);
  });
}

/* ---- Count animation ---- */
function initCountAnimation() {
  const numbers = document.querySelectorAll('.hero__stat-number');
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const el = entry.target;
        const target = parseInt(el.dataset.count, 10);
        if (!target) return;
        let current = 0;
        const step = Math.ceil(target / 30);
        const timer = setInterval(() => {
          current += step;
          if (current >= target) { current = target; clearInterval(timer); }
          el.textContent = current;
        }, 50);
        observer.unobserve(el);
      }
    });
  }, { threshold: 0.5 });
  numbers.forEach(n => observer.observe(n));
}
