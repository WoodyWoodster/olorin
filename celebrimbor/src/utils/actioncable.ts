import * as ActionCable from '@rails/actioncable'

// Create ActionCable consumer
// JWT authentication is handled via httpOnly cookies automatically sent with the WebSocket connection
// In development, this will typically be ws://localhost:3000/cable
// In production, use the environment variable
function createCableConnection() {
  const baseUrl = import.meta.env.VITE_WEBSOCKET_URL || 'ws://localhost:3000/cable'

  // No need to append token - httpOnly cookie is automatically sent with WebSocket handshake
  return ActionCable.createConsumer(baseUrl)
}

const cable = createCableConnection()

export default cable
