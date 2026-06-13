import { firebaseConfig } from "./config.js?v=1.6";
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.8.0/firebase-app.js";
import { getFirestore, doc, getDoc, runTransaction } from "https://www.gstatic.com/firebasejs/10.8.0/firebase-firestore.js";
import { getAuth, signInWithEmailAndPassword, onAuthStateChanged } from "https://www.gstatic.com/firebasejs/10.8.0/firebase-auth.js";

// Inicializar Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const auth = getAuth(app);

// Elementos del DOM
const loadingContainer = document.getElementById("loading-container");
const loginContainer = document.getElementById("login-container");
const orderContainer = document.getElementById("order-container");
const successContainer = document.getElementById("success-container");

const loginForm = document.getElementById("login-form");
const loginEmail = document.getElementById("login-email");
const loginPassword = document.getElementById("login-password");
const loginError = document.getElementById("login-error");

const clientNameTitle = document.getElementById("client-name-title");
const orderDate = document.getElementById("order-date");
const sellerNameTitle = document.getElementById("seller-name-title");
const itemsList = document.getElementById("items-list");
const orderTotal = document.getElementById("order-total");
const orderStatusBadge = document.getElementById("order-status-badge");
const confirmBtn = document.getElementById("confirm-btn");
const actionContainer = document.getElementById("action-container");

// Obtener ID del Pedido
const urlParams = new URLSearchParams(window.location.search);
const orderId = urlParams.get("id");

let currentOrderData = null;

// Escuchar Estado de Autenticación
onAuthStateChanged(auth, async (user) => {
  if (!user) {
    showScreen(loginContainer);
  } else {
    if (!orderId) {
      alert("Error: No se especificó el ID del pedido.");
      loadingContainer.innerHTML = `<p class="text-red-400 font-semibold">Falta el parámetro ID del pedido en la URL.</p>`;
      showScreen(loadingContainer);
      return;
    }
    await loadOrderDetails();
  }
});

// Manejar Login
loginForm.addEventListener("submit", async (e) => {
  e.preventDefault();
  loginError.classList.add("hidden");
  
  const email = loginEmail.value.trim();
  const password = loginPassword.value.trim();
  
  try {
    showScreen(loadingContainer);
    await signInWithEmailAndPassword(auth, email, password);
  } catch (err) {
    console.error("Login failed:", err);
    loginError.innerText = "Credenciales incorrectas o error de conexión.";
    loginError.classList.remove("hidden");
    showScreen(loginContainer);
  }
});

// Cargar Detalles del Pedido
async function loadOrderDetails() {
  showScreen(loadingContainer);
  try {
    const orderRef = doc(db, "pedidos", orderId);
    const orderSnap = await getDoc(orderRef);
    
    if (!orderSnap.exists()) {
      loadingContainer.innerHTML = `<p class="text-red-400 font-semibold">El pedido no existe en la base de datos.</p>`;
      showScreen(loadingContainer);
      return;
    }
    
    currentOrderData = orderSnap.data();
    await renderOrder();
    showScreen(orderContainer);
  } catch (err) {
    console.error("Error loading order:", err);
    loadingContainer.innerHTML = `<p class="text-red-400 font-semibold">Error al cargar el pedido: ${err.message || err}</p>`;
    showScreen(loadingContainer);
  }
}

// Renderizar Datos del Pedido
async function renderOrder() {
  clientNameTitle.innerText = currentOrderData.cliente_nombre || "Cliente Sin Nombre";
  
  // Obtener Nombre del Vendedor
  let sellerName = "Cargando...";
  try {
    const sellerId = currentOrderData.vendedor_id || "vendedor_matias";
    const sellerRef = doc(db, "vendedores", sellerId);
    const sellerSnap = await getDoc(sellerRef);
    if (sellerSnap.exists()) {
      sellerName = sellerSnap.data().nombre || sellerId;
    } else {
      sellerName = sellerId === "vendedor_matias" ? "Matias Cermesoni" : (sellerId === "vendedor_lucas" ? "Lucas Ugolini" : sellerId);
    }
  } catch (err) {
    console.error("Error fetching seller details:", err);
    sellerName = currentOrderData.vendedor_id || "Vendedor";
  }
  sellerNameTitle.innerText = `Vendedor asignado: ${sellerName}`;
  
  // Formatear Fecha
  if (currentOrderData.fecha_creacion) {
    let dateObj;
    if (currentOrderData.fecha_creacion.seconds) {
      dateObj = new Date(currentOrderData.fecha_creacion.seconds * 1000);
    } else {
      dateObj = new Date(currentOrderData.fecha_creacion);
    }
    orderDate.innerText = dateObj.toLocaleString("es-AR", { dateStyle: "medium", timeStyle: "short" });
  } else {
    orderDate.innerText = "";
  }
  
  // Estado
  const isDelivered = currentOrderData.estado === "Entregado";
  orderStatusBadge.innerText = currentOrderData.estado || "Pendiente";
  
  if (isDelivered) {
    orderStatusBadge.className = "px-2.5 py-0.5 rounded-full text-2xs font-bold uppercase tracking-wider bg-emerald-950 text-emerald-300 border border-emerald-800";
    actionContainer.innerHTML = `
      <div class="p-4 bg-emerald-950/60 border border-emerald-800 text-emerald-300 rounded-xl text-sm text-center font-medium">
        Este pedido ya fue entregado y el stock correspondiente fue descontado.
      </div>
    `;
  } else {
    orderStatusBadge.className = "px-2.5 py-0.5 rounded-full text-2xs font-bold uppercase tracking-wider bg-amber-950 text-amber-300 border border-amber-800";
  }
  
  // Renderizar Ítems
  itemsList.innerHTML = "";
  const items = currentOrderData.items || [];
  items.forEach(item => {
    const itemRow = document.createElement("div");
    itemRow.className = "flex justify-between items-center bg-dark-800/80 border border-white/5 p-3 rounded-xl";
    
    const qtyText = `<span class="text-gold-400 font-bold">${item.cantidad}x</span>`;
    const specText = (item.talle || item.color) 
      ? `<span class="text-3xs text-gray-400 block">${item.talle ? 'Talle: ' + item.talle : ''} ${item.color ? ' | Color: ' + item.color : ''}</span>`
      : '';
      
    itemRow.innerHTML = `
      <div>
        <p class="text-xs font-semibold text-white">${qtyText} ${item.nombre}</p>
        ${specText}
      </div>
      <span class="text-xs font-medium text-gray-300">$${Number(item.precio * item.cantidad).toLocaleString("es-AR")}</span>
    `;
    itemsList.appendChild(itemRow);
  });
  
  // Total
  orderTotal.innerText = `$${Number(currentOrderData.total || 0).toLocaleString("es-AR")}`;
}

// Confirmar Entrega (Misma lógica transaccional que en app-v4.js)
confirmBtn.addEventListener("click", async () => {
  if (!confirm("¿Confirmas la entrega de este pedido? Esto descontará de forma permanente los productos del stock disponible.")) {
    return;
  }
  
  showScreen(loadingContainer);
  
  try {
    const orderRef = doc(db, "pedidos", orderId);
    
    await runTransaction(db, async (transaction) => {
      const orderSnap = await transaction.get(orderRef);
      if (!orderSnap.exists()) {
        throw "El pedido no existe.";
      }
      const orderData = orderSnap.data();
      if (orderData.estado === 'Entregado') {
        throw "El pedido ya fue marcado como entregado.";
      }
      
      const items = orderData.items || [];
      for (let item of items) {
        if (item.producto_ref) {
          const prodSnap = await transaction.get(item.producto_ref);
          if (prodSnap.exists()) {
            const prodData = prodSnap.data();
            if (prodData.control_stock === true) {
              const currentStock = Number(prodData.stock || 0);
              const newStock = currentStock - Number(item.cantidad || 0);
              transaction.update(item.producto_ref, { stock: newStock < 0 ? 0 : newStock });
            }
          }
        }
      }
      
      transaction.update(orderRef, { estado: 'Entregado' });
    });
    
    showScreen(successContainer);
  } catch (err) {
    console.error("Transaction failed:", err);
    alert("Error al confirmar entrega: " + err);
    showScreen(orderContainer);
  }
});

// Utilidad de Navegación de Pantallas
function showScreen(screen) {
  loadingContainer.classList.add("hidden");
  loginContainer.classList.add("hidden");
  orderContainer.classList.add("hidden");
  successContainer.classList.add("hidden");
  
  screen.classList.remove("hidden");
}
