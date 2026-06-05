// Configuración de Firebase para el Portal Administrador
// Remplaza los valores de abajo con las credenciales de tu proyecto Firebase.
// Puedes encontrarlas en la consola de Firebase > Configuración del Proyecto > General > Tus Apps.

export const firebaseConfig = {
  apiKey: "AIzaSyDhRrSjQja8k9Vj2IJXQcI-MHjPFP7HfrA",
  authDomain: "app-pedidos-component-63dcf.firebaseapp.com",
  projectId: "app-pedidos-component-63dcf",
  storageBucket: "app-pedidos-component-63dcf.firebasestorage.app",
  messagingSenderId: "308853230269",
  appId: "1:308853230269:web:0a8905528009fc15aa85d4",
  measurementId: "G-SFC61VSFJ9"
};

// Determina si debemos ejecutar el panel en modo offline simulado (Mock Mode)
// para pruebas locales previas a configurar Firebase de forma real.
export const isMockMode = () => {
  return firebaseConfig.apiKey.includes("TU_API_KEY") || 
         firebaseConfig.apiKey === "" ||
         firebaseConfig.projectId === "TU_PROJECT_ID";
};
