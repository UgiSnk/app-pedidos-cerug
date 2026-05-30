// Configuración de Firebase para el Portal Administrador
// Remplaza los valores de abajo con las credenciales de tu proyecto Firebase.
// Puedes encontrarlas en la consola de Firebase > Configuración del Proyecto > General > Tus Apps.

export const firebaseConfig = {
  apiKey: "TU_API_KEY_AQUI",
  authDomain: "TU_PROJECT_ID.firebaseapp.com",
  projectId: "TU_PROJECT_ID",
  storageBucket: "TU_PROJECT_ID.appspot.com",
  messagingSenderId: "TU_SENDER_ID",
  appId: "TU_APP_ID"
};

// Determina si debemos ejecutar el panel en modo offline simulado (Mock Mode)
// para pruebas locales previas a configurar Firebase de forma real.
export const isMockMode = () => {
  return firebaseConfig.apiKey.includes("TU_API_KEY") || 
         firebaseConfig.apiKey === "" ||
         firebaseConfig.projectId === "TU_PROJECT_ID";
};
