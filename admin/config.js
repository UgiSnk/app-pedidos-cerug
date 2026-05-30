// Configuración de Firebase para el Portal Administrador
// Remplaza los valores de abajo con las credenciales de tu proyecto Firebase.
// Puedes encontrarlas en la consola de Firebase > Configuración del Proyecto > General > Tus Apps.

export const firebaseConfig = {
  apiKey: "AIzaSyAE5ad-5hGxRcHAUROLX0GWw5qwPFpWueY",
  authDomain: "app-pedidos-component.firebaseapp.com",
  projectId: "app-pedidos-component",
  storageBucket: "app-pedidos-component.firebasestorage.app",
  messagingSenderId: "181111764963",
  appId: "1:181111764963:web:3921abbf3ba701617052d6",
  measurementId: "G-4CE8Z970L3"
};

// Determina si debemos ejecutar el panel en modo offline simulado (Mock Mode)
// para pruebas locales previas a configurar Firebase de forma real.
export const isMockMode = () => {
  return firebaseConfig.apiKey.includes("TU_API_KEY") || 
         firebaseConfig.apiKey === "" ||
         firebaseConfig.projectId === "TU_PROJECT_ID";
};
