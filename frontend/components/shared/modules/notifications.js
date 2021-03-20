function showNotification(status, message) {
  const notification = document.createElement("div")
  notification.classList.add("notification")
  notification.classList.add(status)
  notification.innerHTML = message
  document.getElementById("notifications").append(notification)
  setTimeout(() => notification.remove(), 2500)
}

export { showNotification }
