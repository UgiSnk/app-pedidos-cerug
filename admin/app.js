// ==========================================================================
// ⚙️ Portal Administrador - Lógica de Control y Conexión a Firebase/Mock
// ==========================================================================

import { firebaseConfig, isMockMode } from "./config.js";

// Importaciones dinámicas del SDK de Firebase desde CDN
let db, storage, auth;
let initialized = false;

const useMock = isMockMode();

// Datos Simulados Iniciales (Mock Data de Velas y Vidrios)
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

const defaultMockVendedor = {
  nombre: 'Component New House',
  telefono: '5491173564074',
  miniatura: 'https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq'
};

// Inicialización de la base de datos (Firebase o LocalStorage)
async function initDatabase() {
  if (useMock) {
    console.log("🚀 Iniciando en Modo Offline Simulador (Mock Mode)");
    if (!localStorage.getItem("admin_productos")) {
      localStorage.setItem("admin_productos", JSON.stringify(defaultMockProductos));
    }
    if (!localStorage.getItem("admin_vendedor")) {
      localStorage.setItem("admin_vendedor", JSON.stringify(defaultMockVendedor));
    }
    updateConnectionBadge(true);
    initialized = true;
    checkAuthState();
  } else {
    try {
      console.log("🔗 Conectando al SDK de Firebase...");
      
      // Importamos dinámicamente los CDN de Firebase
      const firebaseApp = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-app.js");
      const firestoreSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-firestore.js");
      const storageSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-storage.js");
      const authSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-auth.js");

      const app = firebaseApp.initializeApp(firebaseConfig);
      db = firestoreSdk.getFirestore(app);
      storage = storageSdk.getStorage(app);
      auth = authSdk.getAuth(app);

      updateConnectionBadge(false);
      
      // Suscribirse a cambios de Auth
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
      // Fallback a mock si falla la conexión o hay error
      localStorage.setItem("admin_productos", localStorage.getItem("admin_productos") || JSON.stringify(defaultMockProductos));
      localStorage.setItem("admin_vendedor", localStorage.getItem("admin_vendedor") || JSON.stringify(defaultMockVendedor));
      initialized = true;
      checkAuthState();
    }
  }
}

// Actualiza el indicador de conexión superior
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

// Control de vistas de sesión
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

// Cargar y pintar datos generales
let allProducts = [];
let vendorData = {};

async function loadInitialData() {
  try {
    if (useMock) {
      allProducts = JSON.parse(localStorage.getItem("admin_productos") || "[]");
      vendorData = JSON.parse(localStorage.getItem("admin_vendedor") || "{}");
    } else {
      // Leer de Firestore real
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

      // Vendedor
      const sellerSnap = await firestoreSdk.getDocs(firestoreSdk.collection(db, "vendedores"));
      if (!sellerSnap.empty) {
        const doc = sellerSnap.docs[0];
        const data = doc.data();
        vendorData = {
          id: doc.id,
          nombre: data.nombre || 'Component New House',
          telefono: data.telefono || '',
          miniatura: data.miniatura || ''
        };
      } else {
        vendorData = defaultMockVendedor;
      }
    }

    renderDashboardStats();
    renderProductsTable();
    populateStoreSettings();
  } catch (error) {
    console.error("Error cargando base de datos:", error);
  }
}

// Pintar estadísticas en dashboard
function renderDashboardStats() {
  document.getElementById("stat-products-count").innerText = allProducts.length;
  
  // Categorías distintas
  const categories = [...new Set(allProducts.map(p => p.categoria_id))].filter(Boolean);
  document.getElementById("stat-categories-count").innerText = categories.length;
  
  document.getElementById("stat-vendedor-phone").innerText = vendorData.telefono || "Sin registrar";
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
        <span class="px-2.5 py-1 rounded-full text-xs font-semibold ${p.categoria_id === 'Velas' ? 'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20' : 'bg-cyan-500/10 text-cyan-400 border border-cyan-500/20'}">
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

  // Listener para botones de fila
  document.querySelectorAll(".edit-prod-btn").forEach(btn => {
    btn.addEventListener("click", () => openProductModal(btn.dataset.id));
  });
  document.querySelectorAll(".delete-prod-btn").forEach(btn => {
    btn.addEventListener("click", () => deleteProduct(btn.dataset.id));
  });
}

// Pintar configuración del Vendedor
function populateStoreSettings() {
  document.getElementById("store-name").value = vendorData.nombre || "";
  document.getElementById("store-phone").value = vendorData.telefono || "";
  document.getElementById("store-avatar-url").value = vendorData.miniatura || "";
  
  updateStorePreview();
}

function updateStorePreview() {
  const name = document.getElementById("store-name").value || "Tu Tienda";
  const phone = document.getElementById("store-phone").value || "54911XXXXXXXX";
  const avatar = document.getElementById("store-avatar-url").value || "https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq";
  
  document.getElementById("preview-store-avatar").src = avatar;
  document.getElementById("preview-store-name").innerText = name;
  document.getElementById("preview-store-phone").innerText = "WhatsApp: " + phone;
}

// Subida local o Firebase de imágenes
let selectedImageFile = null;

// Conversor a Base64 para almacenar fotos localmente en localStorage en modo offline
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
    // Modo offline simulado -> Cualquier usuario entra
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
  const sections = ["section-dashboard", "section-products", "section-store"];
  sections.forEach(s => {
    document.getElementById(s).classList.add("hidden");
  });
  document.getElementById(sectionId).classList.remove("hidden");

  const navButtons = ["nav-btn-dashboard", "nav-btn-products", "nav-btn-store"];
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
document.getElementById("nav-btn-store").addEventListener("click", () => switchSection("section-store", "nav-btn-store"));


// ==========================================
// 🔍 FILTROS Y BÚSQUEDA
// ==========================================
document.getElementById("search-input").addEventListener("input", renderProductsTable);
document.getElementById("filter-category").addEventListener("change", renderProductsTable);


// ==========================================
// 📦 OPERACIONES CRUD (PRODUCTOS)
// ==========================================
const modal = document.getElementById("product-modal");

function openProductModal(productId = null) {
  selectedImageFile = null;
  document.getElementById("product-form").reset();
  
  const previewImg = document.getElementById("product-preview-img");
  const placeholder = document.getElementById("product-preview-placeholder");
  previewImg.classList.add("hidden");
  previewImg.src = "";
  placeholder.classList.remove("hidden");

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
  
  modal.classList.remove("hidden");
}

function closeModal() {
  modal.classList.add("hidden");
}

document.getElementById("add-product-btn").addEventListener("click", () => openProductModal());
document.getElementById("close-modal-btn").addEventListener("click", closeModal);
document.getElementById("cancel-modal-btn").addEventListener("click", closeModal);

// Drag & Drop de imagen
const imageInput = document.getElementById("image-file-input");
const dropzone = imageInput.parentElement;

imageInput.addEventListener("change", (e) => {
  if (e.target.files.length > 0) {
    handleSelectedImage(e.target.files[0]);
  }
});

dropzone.addEventListener("dragover", (e) => {
  e.preventDefault();
  dropzone.classList.add("dragover");
});

dropzone.addEventListener("dragleave", () => {
  dropzone.classList.remove("dragover");
});

dropzone.addEventListener("drop", (e) => {
  e.preventDefault();
  dropzone.classList.remove("dragover");
  if (e.dataTransfer.files.length > 0) {
    handleSelectedImage(e.dataTransfer.files[0]);
  }
});

function handleSelectedImage(file) {
  selectedImageFile = file;
  const previewImg = document.getElementById("product-preview-img");
  const placeholder = document.getElementById("product-preview-placeholder");
  
  const reader = new FileReader();
  reader.onload = (e) => {
    previewImg.src = e.target.result;
    previewImg.classList.remove("hidden");
    placeholder.classList.add("hidden");
  };
  reader.readAsDataURL(file);
}

// Envío del Formulario (Guardar / Actualizar)
document.getElementById("product-form").addEventListener("submit", async (e) => {
  e.preventDefault();
  
  const idInput = document.getElementById("product-modal-id").value;
  const name = document.getElementById("product-name").value.trim();
  const category = document.getElementById("product-category").value;
  const price = Number(document.getElementById("product-price").value);
  const desc = document.getElementById("product-desc").value.trim();
  const urlInput = document.getElementById("product-img-url").value.trim();

  let finalImageUrl = urlInput || "https://lh3.googleusercontent.com/d/1bbKIYxQfnJWXDrQtKF7sxVblnhSjRkZq";

  // Subir imagen si se seleccionó archivo local
  if (selectedImageFile) {
    if (useMock) {
      // Guardar localmente en formato base64 para persistir sin internet
      finalImageUrl = await convertFileToBase64(selectedImageFile);
    } else {
      // Subir real a Firebase Storage
      try {
        const storageSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-storage.js");
        const uniqueName = Date.now() + "_" + selectedImageFile.name;
        const imgRef = storageSdk.ref(storage, "productos/" + uniqueName);
        const uploadResult = await storageSdk.uploadBytes(imgRef, selectedImageFile);
        finalImageUrl = await storageSdk.getDownloadURL(uploadResult.ref);
      } catch (err) {
        console.error("Error al subir foto a Firebase Storage:", err);
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
    // CRUD en LocalStorage
    let products = JSON.parse(localStorage.getItem("admin_productos") || "[]");
    if (idInput) {
      // Actualizar existente
      products = products.map(p => p.id === idInput ? productData : p);
    } else {
      // Insertar nuevo
      // Validar si existe duplicado
      if (products.some(p => p.id === generatedId)) {
        alert("Ya existe un producto con un nombre similar.");
        return;
      }
      products.push(productData);
    }
    localStorage.setItem("admin_productos", JSON.stringify(products));
  } else {
    // CRUD en Firestore Real
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
      console.error("Error guardando en Firestore:", err);
      alert("Error al guardar en el servidor.");
      return;
    }
  }

  closeModal();
  loadInitialData();
});

// Eliminar Producto
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
      console.error("Error eliminando de Firestore:", err);
      alert("No se pudo eliminar el producto del servidor.");
      return;
    }
  }

  loadInitialData();
}


// ==========================================
// ⚙️ ACTUALIZAR CONFIGURACIÓN DE VENDEDOR
// ==========================================
document.getElementById("store-name").addEventListener("input", updateStorePreview);
document.getElementById("store-phone").addEventListener("input", updateStorePreview);
document.getElementById("store-avatar-url").addEventListener("input", updateStorePreview);

document.getElementById("store-form").addEventListener("submit", async (e) => {
  e.preventDefault();
  
  const name = document.getElementById("store-name").value.trim();
  const phone = document.getElementById("store-phone").value.trim();
  const avatar = document.getElementById("store-avatar-url").value.trim();

  const newVendorData = {
    nombre: name,
    telefono: phone,
    miniatura: avatar
  };

  if (useMock) {
    localStorage.setItem("admin_vendedor", JSON.stringify(newVendorData));
    alert("Configuración de vendedor local actualizada.");
  } else {
    try {
      const firestoreSdk = await import("https://www.gstatic.com/firebasejs/10.8.0/firebase-firestore.js");
      const coll = firestoreSdk.collection(db, "vendedores");
      const snap = await firestoreSdk.getDocs(coll);
      
      if (!snap.empty) {
        // Actualizar el primer documento
        const docRef = firestoreSdk.doc(db, "vendedores", snap.docs[0].id);
        await firestoreSdk.updateDoc(docRef, newVendorData);
      } else {
        // Crear documento nuevo
        const docRef = firestoreSdk.doc(db, "vendedores", "vendedor_component");
        await firestoreSdk.setDoc(docRef, newVendorData);
      }
      alert("Configuración de vendedor actualizada en Firestore.");
    } catch (err) {
      console.error("Error actualizando vendedor:", err);
      alert("Ocurrió un error al actualizar los datos en el servidor.");
      return;
    }
  }

  loadInitialData();
});

// Inicialización del script
window.addEventListener("DOMContentLoaded", () => {
  initDatabase();
  switchSection("section-dashboard", "nav-btn-dashboard");
});
