// ==========================================================================
// ⚙️ Portal Administrador - Lógica de Control y Conexión a Firebase/Mock
// ==========================================================================

import { firebaseConfig, isMockMode } from "./config.js?v=1.1";

// SDKs de Firebase cargados dinámicamente desde CDN
let db, storage, auth;
let initialized = false;

const useMock = isMockMode();

// Datos Simulados por Defecto (Mock Data)
const defaultMockProductos = [
  { id: 'Vela-Grande-Blanco', nombre: 'Vela Grande Blanco', precio: 22000, foto: 'https://lh3.googleusercontent.com/d/1ljXdhXarysJ4_MpUwdWYg9RuyAKDRjUK', categoria_id: 'Velas', descripcion: 'Medida 18x10' },
  { id: 'Vela-Grande-Negro', nombre: 'Vela Grande Negro', precio: 22000, foto: 'https://lh3.googleusercontent.com/d/19p6ToRtzfrPeHGZ9xZ-AD0KwfeiY3XH-', categoria_id: 'Velas', descripcion: 'Medida 18x10' },
  { id: 'Vela-Grande-Verde', nombre: 'Vela Grande Verde', precio: 22000, foto: 'https://lh3.googleusercontent.com/d/13beVbgzBrbxs3INV-852e37rsnkzsFW-', categoria_id: 'Velas', descripcion: 'Medida 18x10' },
  { id: 'Vela-XL-Blanco', nombre: 'Vela XL Blanco', precio: 25000, foto: 'https://lh3.googleusercontent.com/d/1ZyGz0Cymz-1jupj0mMTj8zVpOBt7QY_C', categoria_id: 'Velas', descripcion: 'Medida 25x10' },
  { id: 'Vela-XL-Negro', nombre: 'Vela XL Negro', precio: 25000, foto: 'https://lh3.googleusercontent.com/d/1MDjZsrFP_BBMzb6HzbdPOWkzoSG0ard0', categoria_id: 'Velas', descripcion: 'Medida 25x10' },
  { id: 'Vela-XL-Verde', nombre: 'Vela XL Verde', precio: 25000, foto: 'https://lh3.googleusercontent.com/d/1DMnd1n4iJKvbZk6S4GN6Xq0NJ8RIfByc', categoria_id: 'Velas', descripcion: 'Medida 25x10' },
  { id: 'Vela-XXL-Blanco', nombre: 'Vela XXL Blanco', precio: 28000, foto: 'https://lh3.googleusercontent.com/d/1KIJ9KKdaMylPUTSEVXfhjTNKB5kWgVW8', categoria_id: 'Velas', descripcion: 'Medida 15x17' },
  { id: 'Vela-XXL-Negro', nombre: 'Vela XXL Negro', precio: 28000, foto: 'https://lh3.googleusercontent.com/d/1IDQVzbuaUoHKwUtOf0PZNRmsdAoKvShG', categoria_id: 'Velas', descripcion: 'Medida 15x17' },
  { id: 'Vela-XXL-Verde', nombre: 'Vela XXL Verde', precio: 28000, foto: 'https://lh3.googleusercontent.com/d/1WAKDunDwINTxXP_ac_PQeCoaUK_sukOV', categoria_id: 'Velas', descripcion: 'Medida 15x17' },
  { id: 'Vaso-chico-con-vela', nombre: 'Vaso chico con vela', precio: 32000, foto: 'https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq', categoria_id: 'Velas', descripcion: 'Aromática' },
  { id: 'Vaso-grande-con-vela', nombre: 'Vaso grande con vela', precio: 50000, foto: 'https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq', categoria_id: 'Velas', descripcion: 'Aromática' },
  
  { id: 'Vidrio-1', nombre: 'Vidrio 1', precio: 25000, foto: 'https://lh3.googleusercontent.com/d/11oF3-k-tSV7FZZz9oI3RDkMrXF4VkI8b', categoria_id: 'Vidrios', descripcion: '' },
  { id: 'Vidrio-2', nombre: 'Vidrio 2', precio: 25000, foto: 'https://lh3.googleusercontent.com/d/1JN0g9JRX2A74qKVDP70hiZrsC36diV4j', categoria_id: 'Vidrios', descripcion: '' },
  { id: 'Vidrio-3', nombre: 'Vidrio 3', precio: 28000, foto: 'https://lh3.googleusercontent.com/d/1lkkB3V5tNpzJbJmrZtcUkR8FiMDtEI3H', categoria_id: 'Vidrios', descripcion: '' },
  { id: 'Vidrio-4', nombre: 'Vidrio 4', precio: 28000, foto: 'https://lh3.googleusercontent.com/d/1rTzwMQBTuWG8QMII4m2OvQXWyAKXvCCu', categoria_id: 'Vidrios', descripcion: '' },
  { id: 'Vidrio-5', nombre: 'Vidrio 5', precio: 28000, foto: 'https://lh3.googleusercontent.com/d/1h4WXu0gKNpoAraSkcGSGJS61Lp-vJ-Lh', categoria_id: 'Vidrios', descripcion: '' },
  { id: 'Vidrio-6', nombre: 'Vidrio 6', precio: 32000, foto: 'https://lh3.googleusercontent.com/d/1RE3w4WGCl8n9qj1UXUA4SZGzDQuuBWCp', categoria_id: 'Vidrios', descripcion: '' },
  { id: 'Vidrio-7', nombre: 'Vidrio 7', precio: 50000, foto: 'https://lh3.googleusercontent.com/d/1SENQbB7MMbJz5IDNsg7cXlaeNpgYXHWO', categoria_id: 'Vidrios', descripcion: '' },
  { id: 'Vidrio-8', nombre: 'Vidrio 8', precio: 50000, foto: 'https://lh3.googleusercontent.com/d/1HWGPGJvXRpjCSE1MTSW6tBuGgf3NjMMu', categoria_id: 'Vidrios', descripcion: '' }
];

const defaultMockCategorias = [
  { id: 'Velas', nombre: 'Velas', imagen: 'https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq' },
  { id: 'Vidrios', nombre: 'Vidrios', imagen: 'https://lh3.googleusercontent.com/d/1ebuXB_EbgPhsZefF7RiE0FRLKEAP3raC' }
];

const defaultMockVendedores = [
  { id: 'vendedor_component', nombre: 'Component New House', telefono: '5491173564074', miniatura: 'https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq' }
];

// Variables globales de datos cargados
let allProducts = [];
let allCategories = [];
let allSellers = [];

// Inicialización de base de datos
async function initDatabase() {
  if (useMock) {
    console.log("🚀 Iniciando en Modo Offline Simulador (Mock Mode)");
    if (!localStorage.getItem("admin_productos")) {
      localStorage.setItem("admin_productos", JSON.stringify(defaultMockProductos));
    }
    if (!localStorage.getItem("admin_categorias")) {
      localStorage.setItem("admin_categorias", JSON.stringify(defaultMockCategorias));
    }
    if (!localStorage.getItem("admin_vendedores")) {
      localStorage.setItem("admin_vendedores", JSON.stringify(defaultMockVendedores));
    }
    updateConnectionBadge(true);
    initialized = true;
    checkAuthState();
  } else {
    try {
      console.log("🔗 Conectando al SDK de Firebase...");
      
      const firebaseApp = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-app.js");
      const firestoreSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-firestore.js");
      const storageSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-storage.js");
      const authSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-auth.js");

      const app = firebaseApp.initializeApp(firebaseConfig);
      db = firestoreSdk.getFirestore(app);
      storage = storageSdk.getStorage(app);
      auth = authSdk.getAuth(app);

      updateConnectionBadge(false);
      
      authSdk.onAuthStateChanged(auth, (user) => {
        if (user) {
          showDashboard(user.email);
        } else {
          showLogin();
        }
      });
      initialized = true;
    } catch (error) {
      console.error("❌ Error de inicio Firebase. Cambiando a Modo Simulado:", error);
      updateConnectionBadge(true, true);
      localStorage.setItem("admin_productos", localStorage.getItem("admin_productos") || JSON.stringify(defaultMockProductos));
      localStorage.setItem("admin_categorias", localStorage.getItem("admin_categorias") || JSON.stringify(defaultMockCategorias));
      localStorage.setItem("admin_vendedores", localStorage.getItem("admin_vendedores") || JSON.stringify(defaultMockVendedores));
      initialized = true;
      checkAuthState();
    }
  }
}

function updateConnectionBadge(isMock, hasError = false) {
  const badge = document.getElementById("db-status-badge");
  const text = document.getElementById("db-status-text");
  
  if (isMock) {
    badge.className = "flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-semibold bg-yellow-500/10 text-yellow-400 border border-yellow-500/20";
    badge.querySelector("span").className = "h-2 w-2 rounded-full bg-yellow-400 animate-pulse";
    text.innerText = hasError ? "Error Firebase - Modo Simulado" : "Simulador Local Offline";
    document.getElementById("offline-login-tip").classList.remove("hidden");
  } else {
    badge.className = "flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-semibold bg-emerald-500/10 text-emerald-400 border border-emerald-500/20";
    badge.querySelector("span").className = "h-2 w-2 rounded-full bg-emerald-400 animate-pulse";
    text.innerText = "Conectado a Firebase Real";
    document.getElementById("offline-login-tip").classList.add("hidden");
  }
}

function checkAuthState() {
  const loggedIn = localStorage.getItem("admin_logged_in") === "true";
  const userEmail = localStorage.getItem("admin_user_email") || "simulado@tienda.com";
  
  if (loggedIn) {
    showDashboard(userEmail);
  } else {
    showLogin();
  }
}

function showDashboard(email) {
  document.getElementById("login-screen").classList.add("hidden");
  document.getElementById("app-layout").classList.remove("hidden");
  document.getElementById("user-display-email").innerText = email;
  loadInitialData();
}

function showLogin() {
  document.getElementById("login-screen").classList.remove("hidden");
  document.getElementById("app-layout").classList.add("hidden");
}

// Cargar y pintar datos de colecciones
async function loadInitialData() {
  try {
    if (useMock) {
      allProducts = JSON.parse(localStorage.getItem("admin_productos") || "[]");
      allCategories = JSON.parse(localStorage.getItem("admin_categorias") || "[]");
      allSellers = JSON.parse(localStorage.getItem("admin_vendedores") || "[]");
    } else {
      const firestoreSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-firestore.js");
      
      // Productos
      const prodSnap = await firestoreSdk.getDocs(firestoreSdk.collection(db, "productos"));
      allProducts = [];
      prodSnap.forEach(doc => {
        const data = doc.data();
        allProducts.push({
          id: doc.id,
          nombre: data.nombre || 'Producto',
          precio: Number(data.precio || 0),
          foto: data.foto || '',
          categoria_id: data.categoria_id || '',
          descripcion: data.descripcion || ''
        });
      });

      // Categorías
      const catSnap = await firestoreSdk.getDocs(firestoreSdk.collection(db, "categorias"));
      allCategories = [];
      catSnap.forEach(doc => {
        const data = doc.data();
        allCategories.push({
          id: doc.id,
          nombre: data.nombre || doc.id,
          imagen: data.imagen || ''
        });
      });
      if (allCategories.length === 0) allCategories = defaultMockCategorias;

      // Vendedores
      const sellerSnap = await firestoreSdk.getDocs(firestoreSdk.collection(db, "vendedores"));
      allSellers = [];
      sellerSnap.forEach(doc => {
        const data = doc.data();
        allSellers.push({
          id: doc.id,
          nombre: data.nombre || 'Vendedor',
          telefono: data.telefono || '',
          miniatura: data.miniatura || ''
        });
      });
      if (allSellers.length === 0) allSellers = defaultMockVendedores;
    }

    renderDashboardStats();
    populateSelectFilters();
    renderProductsTable();
    renderCategoriesGrid();
    renderSellersGrid();
  } catch (error) {
    console.error("Error cargando base de datos:", error);
  }
}

// Pintar estadísticas en dashboard
function renderDashboardStats() {
  document.getElementById("stat-products-count").innerText = allProducts.length;
  document.getElementById("stat-categories-count").innerText = allCategories.length;
  document.getElementById("stat-sellers-count").innerText = allSellers.length;
  
  const primeSeller = allSellers[0];
  document.getElementById("stat-vendedor-phone").innerText = primeSeller ? `${primeSeller.nombre} (${primeSeller.telefono})` : "Sin registrar";
}

// Rellenar dinámicamente los selects de categorías en la UI
function populateSelectFilters() {
  const filterSelect = document.getElementById("filter-category");
  const modalSelect = document.getElementById("product-category");
  
  const selectedFilterValue = filterSelect.value || "all";
  const selectedModalValue = modalSelect.value || "";

  filterSelect.innerHTML = `<option value="all">Todas las Categorías</option>`;
  modalSelect.innerHTML = "";

  allCategories.forEach(cat => {
    // Opción en filtro
    const optF = document.createElement("option");
    optF.value = cat.id;
    optF.innerText = cat.nombre;
    filterSelect.appendChild(optF);

    // Opción en modal
    const optM = document.createElement("option");
    optM.value = cat.id;
    optM.innerText = cat.nombre;
    modalSelect.appendChild(optM);
  });

  filterSelect.value = selectedFilterValue;
  if (selectedModalValue) modalSelect.value = selectedModalValue;
}

// Pintar listado de productos
function renderProductsTable() {
  const tbody = document.getElementById("products-table-body");
  const searchValue = document.getElementById("search-input").value.toLowerCase().trim();
  const filterCat = document.getElementById("filter-category").value;

  tbody.innerHTML = "";

  const filtered = allProducts.filter(product => {
    const matchesSearch = product.nombre.toLowerCase().includes(searchValue);
    const matchesCategory = filterCat === "all" || product.categoria_id === filterCat;
    return matchesSearch && matchesCategory;
  });

  if (filtered.length === 0) {
    document.getElementById("no-products-view").classList.remove("hidden");
    return;
  }
  document.getElementById("no-products-view").classList.add("hidden");

  filtered.forEach(p => {
    const tr = document.createElement("tr");
    tr.className = "text-sm text-slate-300";
    tr.innerHTML = `
      <td class="py-4 px-6">
        <div class="h-10 w-10 rounded-lg overflow-hidden border border-white/5 bg-slate-900">
          <img src="${p.foto || 'https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq'}" class="h-full w-full object-cover" onerror="this.src='https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq';">
        </div>
      </td>
      <td class="py-4 px-6 font-semibold text-white">${p.nombre}</td>
      <td class="py-4 px-6 text-slate-400">
        <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">
          ${p.categoria_id}
        </span>
      </td>
      <td class="py-4 px-6 font-bold text-white">$${Number(p.precio).toLocaleString('es-AR')}</td>
      <td class="py-4 px-6 text-xs text-slate-400 truncate max-w-[180px]">${p.descripcion || '-'}</td>
      <td class="py-4 px-6">
        <div class="flex justify-center gap-2">
          <button class="edit-prod-btn p-2 bg-slate-800/40 hover:bg-emerald-500/10 hover:text-emerald-400 rounded-xl border border-white/5 transition-all" data-id="${p.id}" title="Editar">
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
          </button>
          <button class="delete-prod-btn p-2 bg-slate-800/40 hover:bg-red-500/10 hover:text-red-400 rounded-xl border border-white/5 transition-all" data-id="${p.id}" title="Eliminar">
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
          </button>
        </div>
      </td>
    `;
    tbody.appendChild(tr);
  });

  // Listeners para botones de la tabla
  document.querySelectorAll(".edit-prod-btn").forEach(btn => {
    btn.addEventListener("click", () => openProductModal(btn.dataset.id));
  });
  document.querySelectorAll(".delete-prod-btn").forEach(btn => {
    btn.addEventListener("click", () => deleteProduct(btn.dataset.id));
  });
}

// Pintar la cuadrícula de categorías
function renderCategoriesGrid() {
  const grid = document.getElementById("categories-grid");
  grid.innerHTML = "";

  allCategories.forEach(cat => {
    const card = document.createElement("div");
    card.className = "glass-card rounded-2xl overflow-hidden border border-white/5 flex flex-col justify-between";
    card.innerHTML = `
      <div class="h-32 bg-slate-900 relative">
        <img src="${cat.imagen || 'https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq'}" class="h-full w-full object-cover" onerror="this.src='https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq';">
        <div class="absolute inset-0 bg-gradient-to-t from-slate-950 to-transparent"></div>
        <h4 class="absolute bottom-4 left-4 text-lg font-bold text-white">${cat.nombre}</h4>
      </div>
      <div class="p-4 flex justify-between items-center bg-slate-900/30">
        <span class="text-xs text-slate-400">${allProducts.filter(p => p.categoria_id === cat.id).length} Productos</span>
        <button class="delete-cat-btn p-2 bg-slate-800/40 hover:bg-red-500/10 hover:text-red-400 rounded-xl border border-white/5 transition-all text-slate-400" data-id="${cat.id}" title="Eliminar Categoría">
          <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
        </button>
      </div>
    `;
    grid.appendChild(card);
  });

  // Listeners
  document.querySelectorAll(".delete-cat-btn").forEach(btn => {
    btn.addEventListener("click", () => deleteCategory(btn.dataset.id));
  });
}

// Pintar la cuadrícula de vendedores
function renderSellersGrid() {
  const grid = document.getElementById("sellers-grid");
  grid.innerHTML = "";

  allSellers.forEach(seller => {
    const card = document.createElement("div");
    card.className = "glass-card p-6 rounded-2xl border border-white/5 flex flex-col items-center text-center space-y-4 justify-between";
    card.innerHTML = `
      <div class="flex flex-col items-center space-y-3 w-full">
        <div class="relative">
          <img src="${seller.miniatura || 'https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq'}" class="h-20 w-20 rounded-full border-2 border-emerald-500/30 object-cover bg-slate-900" onerror="this.src='https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq';">
          <span class="absolute bottom-0 right-0 h-3.5 w-3.5 bg-emerald-500 border-2 border-slate-950 rounded-full"></span>
        </div>
        <div>
          <h4 class="text-lg font-bold text-white">${seller.nombre}</h4>
          <p class="text-xs text-emerald-400 font-medium">ID: ${seller.id}</p>
        </div>
        
        <div class="w-full bg-slate-900/40 p-2.5 rounded-xl border border-white/5 text-xs text-slate-300 flex items-center justify-center gap-2">
          <svg class="h-4 w-4 text-green-400 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.94.725l.548 2.2a1 1 0 01-.321.988l-1.305 1.05a2.11 2.11 0 00-.08 3.13l2.84 2.84a2.11 2.11 0 003.13-.08l1.05-1.305a1 1 0 01.98-.32l2.2.55a1 1 0 01.725.94v3.28a2 2 0 01-2 2h-3c-9.735 0-17.5-7.765-17.5-17.5V5z"/></svg>
          <span class="font-mono">${seller.telefono}</span>
        </div>
      </div>

      <div class="w-full flex gap-2 pt-2 border-t border-white/5 justify-end">
        <button class="edit-seller-btn px-3 py-1.5 bg-slate-800/40 hover:bg-emerald-500/10 hover:text-emerald-400 rounded-lg border border-white/5 transition-all text-xs font-semibold flex items-center gap-1" data-id="${seller.id}">
          <svg class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
          <span>Editar</span>
        </button>
        <button class="delete-seller-btn px-3 py-1.5 bg-slate-800/40 hover:bg-red-500/10 hover:text-red-400 rounded-lg border border-white/5 transition-all text-xs font-semibold text-slate-400 flex items-center gap-1" data-id="${seller.id}">
          <svg class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
          <span>Borrar</span>
        </button>
      </div>
    `;
    grid.appendChild(card);
  });

  // Listeners
  document.querySelectorAll(".edit-seller-btn").forEach(btn => {
    btn.addEventListener("click", () => openSellerModal(btn.dataset.id));
  });
  document.querySelectorAll(".delete-seller-btn").forEach(btn => {
    btn.addEventListener("click", () => deleteSeller(btn.dataset.id));
  });
}

// Helper para convertir archivo local a base64
function convertFileToBase64(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => resolve(reader.result);
    reader.onerror = error => reject(error);
  });
}


// ==========================================
// 🔒 ACCIONES DE AUTENTICACIÓN
// ==========================================
document.getElementById("login-form").addEventListener("submit", async (e) => {
  e.preventDefault();
  const email = document.getElementById("login-email").value.trim();
  const pass = document.getElementById("login-password").value;
  const errDiv = document.getElementById("login-error");
  const errTxt = document.getElementById("login-error-text");

  errDiv.classList.add("hidden");

  if (useMock) {
    localStorage.setItem("admin_logged_in", "true");
    localStorage.setItem("admin_user_email", email);
    showDashboard(email);
  } else {
    try {
      const authSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-auth.js");
      await authSdk.signInWithEmailAndPassword(auth, email, pass);
      localStorage.setItem("admin_logged_in", "true");
      localStorage.setItem("admin_user_email", email);
    } catch (err) {
      console.error(err);
      let errMsg = "Ocurrió un error al ingresar.";
      if (err.code === "auth/invalid-credential" || err.code === "auth/wrong-password" || err.code === "auth/user-not-found") {
        errMsg = "Correo electrónico o contraseña incorrectos.";
      }
      errTxt.innerText = errMsg;
      errDiv.classList.remove("hidden");
    }
  }
});

document.getElementById("logout-btn").addEventListener("click", async () => {
  if (useMock) {
    localStorage.setItem("admin_logged_in", "false");
    showLogin();
  } else {
    const authSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-auth.js");
    await authSdk.signOut(auth);
    localStorage.setItem("admin_logged_in", "false");
    showLogin();
  }
});


// ==========================================
// 🔀 NAVEGACIÓN SIDEBAR
// ==========================================
function switchSection(sectionId, activeBtnId) {
  const sections = ["section-dashboard", "section-products", "section-categories", "section-sellers"];
  sections.forEach(s => {
    document.getElementById(s).classList.add("hidden");
  });
  document.getElementById(sectionId).classList.remove("hidden");

  const navButtons = ["nav-btn-dashboard", "nav-btn-products", "nav-btn-categories", "nav-btn-sellers"];
  navButtons.forEach(btnId => {
    const btn = document.getElementById(btnId);
    if (btnId === activeBtnId) {
      btn.className = "w-full flex items-center gap-3 px-4 py-3 rounded-xl bg-emerald-500 text-white transition-all text-sm font-semibold shadow-lg shadow-emerald-500/10";
    } else {
      btn.className = "w-full flex items-center gap-3 px-4 py-3 rounded-xl text-slate-300 hover:bg-white/5 hover:text-white transition-all text-sm font-medium";
    }
  });
}

document.getElementById("nav-btn-dashboard").addEventListener("click", () => switchSection("section-dashboard", "nav-btn-dashboard"));
document.getElementById("nav-btn-products").addEventListener("click", () => switchSection("section-products", "nav-btn-products"));
document.getElementById("nav-btn-categories").addEventListener("click", () => switchSection("section-categories", "nav-btn-categories"));
document.getElementById("nav-btn-sellers").addEventListener("click", () => switchSection("section-sellers", "nav-btn-sellers"));


// ==========================================
// 🔍 BUSCADOR DE PRODUCTOS
// ==========================================
document.getElementById("search-input").addEventListener("input", renderProductsTable);
document.getElementById("filter-category").addEventListener("change", renderProductsTable);


// ==========================================
// 📦 CRUD: PRODUCTOS (MODAL Y ENVÍO)
// ==========================================
const prodModal = document.getElementById("product-modal");
let prodSelectedFile = null;

function openProductModal(productId = null) {
  prodSelectedFile = null;
  document.getElementById("product-form").reset();
  
  const previewImg = document.getElementById("product-preview-img");
  const placeholder = document.getElementById("product-preview-placeholder");
  previewImg.classList.add("hidden");
  previewImg.src = "";
  placeholder.classList.remove("hidden");

  populateSelectFilters();

  if (productId) {
    document.getElementById("modal-title").innerText = "Editar Producto";
    const prod = allProducts.find(p => p.id === productId);
    if (prod) {
      document.getElementById("product-modal-id").value = prod.id;
      document.getElementById("product-name").value = prod.nombre;
      document.getElementById("product-category").value = prod.categoria_id;
      document.getElementById("product-price").value = prod.precio;
      document.getElementById("product-desc").value = prod.descripcion;
      document.getElementById("product-img-url").value = prod.foto;
      
      if (prod.foto) {
        previewImg.src = prod.foto;
        previewImg.classList.remove("hidden");
        placeholder.classList.add("hidden");
      }
    }
  } else {
    document.getElementById("modal-title").innerText = "Agregar Producto";
    document.getElementById("product-modal-id").value = "";
  }
  
  prodModal.classList.remove("hidden");
}

function closeProductModal() {
  prodModal.classList.add("hidden");
}

document.getElementById("add-product-btn").addEventListener("click", () => openProductModal());
document.getElementById("close-modal-btn").addEventListener("click", closeProductModal);
document.getElementById("cancel-modal-btn").addEventListener("click", closeProductModal);

// Drag & Drop de imagen en Productos
const prodImageInput = document.getElementById("image-file-input");
prodImageInput.addEventListener("change", (e) => {
  if (e.target.files.length > 0) {
    prodSelectedFile = e.target.files[0];
    showLocalPreview(prodSelectedFile, "product-preview-img", "product-preview-placeholder");
  }
});

function showLocalPreview(file, imgId, placeholderId) {
  const img = document.getElementById(imgId);
  const placeholder = document.getElementById(placeholderId);
  const reader = new FileReader();
  reader.onload = (e) => {
    img.src = e.target.result;
    img.classList.remove("hidden");
    placeholder.classList.add("hidden");
  };
  reader.readAsDataURL(file);
}

// Envío del formulario de producto
document.getElementById("product-form").addEventListener("submit", async (e) => {
  e.preventDefault();
  
  const idInput = document.getElementById("product-modal-id").value;
  const name = document.getElementById("product-name").value.trim();
  const category = document.getElementById("product-category").value;
  const price = Number(document.getElementById("product-price").value);
  const desc = document.getElementById("product-desc").value.trim();
  const urlInput = document.getElementById("product-img-url").value.trim();

  let finalImageUrl = urlInput || "https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq";

  if (prodSelectedFile) {
    if (useMock) {
      finalImageUrl = await convertFileToBase64(prodSelectedFile);
    } else {
      try {
        const storageSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-storage.js");
        const uniqueName = Date.now() + "_" + prodSelectedFile.name;
        const imgRef = storageSdk.ref(storage, "productos/" + uniqueName);
        const uploadResult = await storageSdk.uploadBytes(imgRef, prodSelectedFile);
        finalImageUrl = await storageSdk.getDownloadURL(uploadResult.ref);
      } catch (err) {
        console.error("Error cargando foto a Firebase Storage:", err);
      }
    }
  }

  const generatedId = idInput || name.replace(/\s+/g, '-').toLowerCase();

  const productData = {
    id: generatedId,
    nombre: name,
    precio: price,
    foto: finalImageUrl,
    categoria_id: category,
    descripcion: desc
  };

  if (useMock) {
    let products = JSON.parse(localStorage.getItem("admin_productos") || "[]");
    if (idInput) {
      products = products.map(p => p.id === idInput ? productData : p);
    } else {
      if (products.some(p => p.id === generatedId)) {
        alert("Ya existe un producto con un nombre similar.");
        return;
      }
      products.push(productData);
    }
    localStorage.setItem("admin_productos", JSON.stringify(products));
  } else {
    try {
      const firestoreSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-firestore.js");
      const docRef = firestoreSdk.doc(db, "productos", generatedId);
      await firestoreSdk.setDoc(docRef, {
        nombre: name,
        precio: price,
        foto: finalImageUrl,
        categoria_id: category,
        descripcion: desc
      });
    } catch (err) {
      console.error("Error guardando producto en Firestore:", err);
      alert("Error al guardar en el servidor.");
      return;
    }
  }

  closeProductModal();
  loadInitialData();
});

// Borrar producto
async function deleteProduct(productId) {
  if (!confirm("¿Estás seguro de que quieres eliminar este producto?")) return;

  if (useMock) {
    let products = JSON.parse(localStorage.getItem("admin_productos") || "[]");
    products = products.filter(p => p.id !== productId);
    localStorage.setItem("admin_productos", JSON.stringify(products));
  } else {
    try {
      const firestoreSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-firestore.js");
      const docRef = firestoreSdk.doc(db, "productos", productId);
      await firestoreSdk.deleteDoc(docRef);
    } catch (err) {
      console.error(err);
      alert("Error al borrar de Firestore.");
      return;
    }
  }
  loadInitialData();
}


// ==========================================
// 🗂️ CRUD: CATEGORÍAS (MODAL Y ENVÍO)
// ==========================================
const catModal = document.getElementById("category-modal");
let catSelectedFile = null;

function openCategoryModal() {
  catSelectedFile = null;
  document.getElementById("category-form").reset();
  document.getElementById("category-preview-img").classList.add("hidden");
  document.getElementById("category-preview-placeholder").classList.remove("hidden");
  catModal.classList.remove("hidden");
}

function closeCategoryModal() {
  catModal.classList.add("hidden");
}

document.getElementById("add-category-btn").addEventListener("click", openCategoryModal);
document.getElementById("close-cat-modal-btn").addEventListener("click", closeCategoryModal);
document.getElementById("cancel-cat-modal-btn").addEventListener("click", closeCategoryModal);

// Selección de imagen en Categorías
document.getElementById("category-image-file-input").addEventListener("change", (e) => {
  if (e.target.files.length > 0) {
    catSelectedFile = e.target.files[0];
    showLocalPreview(catSelectedFile, "category-preview-img", "category-preview-placeholder");
  }
});

// Guardar Categoría
document.getElementById("category-form").addEventListener("submit", async (e) => {
  e.preventDefault();
  
  const name = document.getElementById("category-name").value.trim();
  const urlInput = document.getElementById("category-img-url").value.trim();
  const catId = name.replace(/\s+/g, '-').replace(/[^a-zA-Z0-9-]/g, '');

  if (allCategories.some(c => c.id.toLowerCase() === catId.toLowerCase())) {
    alert("Ya existe una categoría con un nombre idéntico o muy similar.");
    return;
  }

  let finalImageUrl = urlInput || "https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq";

  if (catSelectedFile) {
    if (useMock) {
      finalImageUrl = await convertFileToBase64(catSelectedFile);
    } else {
      try {
        const storageSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-storage.js");
        const uniqueName = Date.now() + "_" + catSelectedFile.name;
        const imgRef = storageSdk.ref(storage, "categorias/" + uniqueName);
        const uploadResult = await storageSdk.uploadBytes(imgRef, catSelectedFile);
        finalImageUrl = await storageSdk.getDownloadURL(uploadResult.ref);
      } catch (err) {
        console.error("Error al subir foto de categoría:", err);
      }
    }
  }

  const newCategory = {
    id: catId,
    nombre: name,
    imagen: finalImageUrl
  };

  if (useMock) {
    const categories = JSON.parse(localStorage.getItem("admin_categorias") || "[]");
    categories.push(newCategory);
    localStorage.setItem("admin_categorias", JSON.stringify(categories));
  } else {
    try {
      const firestoreSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-firestore.js");
      const docRef = firestoreSdk.doc(db, "categorias", catId);
      await firestoreSdk.setDoc(docRef, {
        nombre: name,
        imagen: finalImageUrl
      });
    } catch (err) {
      console.error(err);
      alert("Error al guardar categoría en el servidor.");
      return;
    }
  }

  closeCategoryModal();
  loadInitialData();
});

// Borrar Categoría
async function deleteCategory(catId) {
  if (allProducts.some(p => p.categoria_id === catId)) {
    alert("No se puede eliminar esta categoría porque tiene productos vinculados. Elimina o cambia la categoría de esos productos primero.");
    return;
  }

  if (!confirm(`¿Estás seguro de que quieres borrar la categoría "${catId}"?`)) return;

  if (useMock) {
    let categories = JSON.parse(localStorage.getItem("admin_categorias") || "[]");
    categories = categories.filter(c => c.id !== catId);
    localStorage.setItem("admin_categorias", JSON.stringify(categories));
  } else {
    try {
      const firestoreSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-firestore.js");
      const docRef = firestoreSdk.doc(db, "categorias", catId);
      await firestoreSdk.deleteDoc(docRef);
    } catch (err) {
      console.error(err);
      alert("Error al eliminar categoría en Firestore.");
      return;
    }
  }
  loadInitialData();
}


// ==========================================
// 👤 CRUD: VENDEDORES (MODAL Y ENVÍO)
// ==========================================
const sellerModal = document.getElementById("seller-modal");
let sellerSelectedFile = null;

function openSellerModal(sellerId = null) {
  sellerSelectedFile = null;
  document.getElementById("seller-form").reset();
  
  const previewImg = document.getElementById("seller-preview-img");
  const placeholder = document.getElementById("seller-preview-placeholder");
  const idInput = document.getElementById("seller-id");

  previewImg.classList.add("hidden");
  previewImg.src = "";
  placeholder.classList.remove("hidden");
  idInput.removeAttribute("disabled");
  
  if (sellerId) {
    document.getElementById("seller-modal-title").innerText = "Editar Vendedor";
    document.getElementById("seller-is-edit").value = "true";
    
    const seller = allSellers.find(s => s.id === sellerId);
    if (seller) {
      idInput.value = seller.id;
      idInput.setAttribute("disabled", "true"); // No editar ID ya creado
      document.getElementById("seller-name").value = seller.nombre;
      document.getElementById("seller-phone").value = seller.telefono;
      document.getElementById("seller-avatar-url").value = seller.miniatura;
      
      if (seller.miniatura) {
        previewImg.src = seller.miniatura;
        previewImg.classList.remove("hidden");
        placeholder.classList.add("hidden");
      }
    }
  } else {
    document.getElementById("seller-modal-title").innerText = "Agregar Vendedor";
    document.getElementById("seller-is-edit").value = "false";
  }
  
  sellerModal.classList.remove("hidden");
}

function closeSellerModal() {
  sellerModal.classList.add("hidden");
}

document.getElementById("add-seller-btn").addEventListener("click", () => openSellerModal());
document.getElementById("close-seller-modal-btn").addEventListener("click", closeSellerModal);
document.getElementById("cancel-seller-modal-btn").addEventListener("click", closeSellerModal);

// Selección de imagen en Vendedores
document.getElementById("seller-image-file-input").addEventListener("change", (e) => {
  if (e.target.files.length > 0) {
    sellerSelectedFile = e.target.files[0];
    showLocalPreview(sellerSelectedFile, "seller-preview-img", "seller-preview-placeholder");
  }
});

// Guardar Vendedor
document.getElementById("seller-form").addEventListener("submit", async (e) => {
  e.preventDefault();

  const isEdit = document.getElementById("seller-is-edit").value === "true";
  const id = document.getElementById("seller-id").value.trim().toLowerCase().replace(/\s+/g, '_');
  const name = document.getElementById("seller-name").value.trim();
  const phone = document.getElementById("seller-phone").value.trim();
  const urlInput = document.getElementById("seller-avatar-url").value.trim();

  if (!isEdit && allSellers.some(s => s.id === id)) {
    alert("Ya existe un vendedor con este ID único. Introduce otro.");
    return;
  }

  let finalImageUrl = urlInput || "https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq";

  if (sellerSelectedFile) {
    if (useMock) {
      finalImageUrl = await convertFileToBase64(sellerSelectedFile);
    } else {
      try {
        const storageSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-storage.js");
        const uniqueName = Date.now() + "_" + sellerSelectedFile.name;
        const imgRef = storageSdk.ref(storage, "vendedores/" + uniqueName);
        const uploadResult = await storageSdk.uploadBytes(imgRef, sellerSelectedFile);
        finalImageUrl = await storageSdk.getDownloadURL(uploadResult.ref);
      } catch (err) {
        console.error("Error al subir foto de vendedor:", err);
      }
    }
  }

  const newSellerData = {
    id: id,
    nombre: name,
    telefono: phone,
    miniatura: finalImageUrl
  };

  if (useMock) {
    let sellers = JSON.parse(localStorage.getItem("admin_vendedores") || "[]");
    if (isEdit) {
      sellers = sellers.map(s => s.id === id ? newSellerData : s);
    } else {
      sellers.push(newSellerData);
    }
    localStorage.setItem("admin_vendedores", JSON.stringify(sellers));
  } else {
    try {
      const firestoreSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-firestore.js");
      const docRef = firestoreSdk.doc(db, "vendedores", id);
      await firestoreSdk.setDoc(docRef, {
        nombre: name,
        telefono: phone,
        miniatura: finalImageUrl
      });
    } catch (err) {
      console.error(err);
      alert("Error al guardar vendedor en Firestore.");
      return;
    }
  }

  closeSellerModal();
  loadInitialData();
});

// Borrar Vendedor
async function deleteSeller(sellerId) {
  if (allSellers.length <= 1) {
    alert("Debe haber por lo menos un vendedor en la base de datos para levantar pedidos.");
    return;
  }
  
  if (!confirm(`¿Estás seguro de que deseas eliminar al vendedor "${sellerId}"?`)) return;

  if (useMock) {
    let sellers = JSON.parse(localStorage.getItem("admin_vendedores") || "[]");
    sellers = sellers.filter(s => s.id !== sellerId);
    localStorage.setItem("admin_vendedores", JSON.stringify(sellers));
  } else {
    try {
      const firestoreSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-firestore.js");
      const docRef = firestoreSdk.doc(db, "vendedores", sellerId);
      await firestoreSdk.deleteDoc(docRef);
    } catch (err) {
      console.error(err);
      alert("Error al eliminar vendedor en Firestore.");
      return;
    }
  }
  loadInitialData();
}


// Inicialización del script
window.addEventListener("DOMContentLoaded", () => {
  initDatabase();
  switchSection("section-dashboard", "nav-btn-dashboard");
});
