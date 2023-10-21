import React from "react";
import { createRoot } from "react-dom/client";
import { isEnvBrowser } from "./utils/misc";
import "./index.css";
import App from "./App";

const root = document.getElementById("root");

if (isEnvBrowser()) {
  // https://i.imgur.com/iPTAdYV.png - Night time img
  root!.style.backgroundImage = 'url("https://i.imgur.com/3pzRj9n.png")';
  root!.style.backgroundSize = "cover";
  root!.style.backgroundRepeat = "no-repeat";
  root!.style.backgroundPosition = "center";
}

createRoot(root!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
