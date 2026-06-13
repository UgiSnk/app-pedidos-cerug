// Configuración de Firebase para el Portal Administrador
// Remplaza los valores de abajo con las credenciales de tu proyecto Firebase.
// Puedes encontrarlas en la consola de Firebase > Configuración del Proyecto > General > Tus Apps.

export const firebaseConfig = {
  apiKey: "AIzaSyCR7yuo3I_a-QsWyitqoB3WWQAwa6Bc1zQ",
  authDomain: "pedidos-ropa-cerug.firebaseapp.com",
  projectId: "pedidos-ropa-cerug",
  storageBucket: "pedidos-ropa-cerug.firebasestorage.app",
  messagingSenderId: "399605296427",
  appId: "1:399605296427:web:ff30364b8fe8d208c3696e",
  measurementId: "G-RP44ZSJ4PS"
};

// Determina si debemos ejecutar el panel en modo offline simulado (Mock Mode)
// para pruebas locales previas a configurar Firebase de forma real.
export const isMockMode = () => {
  return firebaseConfig.apiKey.includes("TU_API_KEY") || 
         firebaseConfig.apiKey === "" ||
         firebaseConfig.projectId === "TU_PROJECT_ID";
};
