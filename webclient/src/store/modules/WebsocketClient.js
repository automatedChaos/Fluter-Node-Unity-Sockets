// initial state
// shape: [{ id, quantity }]
const state = () => ({
  serverAddress: 'ws://34.80.38.153:8081',
  socket: null,
  isConnected: false,
  connectionKey: 'null',
  connectionType: 'client'
})

// getters
const getters = {
  serverAddress: (state) => {
    return state.serverAddress
  },

  serverConnected: (state) => {
    return state.isConnected
  },

  connectionKey: (state) => {
    return state.connectionKey
  }
}

// actions
const actions = {

  connectToServer ({ state, commit, dispatch }) {
    
    let ws = new WebSocket(state.serverAddress)
    
    ws.onopen = function () {
      console.log("CONNECTED")
      commit('setSocket', ws)
    }

    ws.onclose = function () {
      console.log("DISCONNECTED")
      commit('disconnect')
    }

    ws.onmessage = function (evt) { 
      var message = JSON.parse(evt.data)
      
      switch (message.action) {
        case 'new-connection':
          commit('setConnectionKey', message.data)
          dispatch('registerAsPlayer')
          break
        default:
          console.log("NOPE")
      }
    }
  },

  registerAsPlayer ({dispatch}) {

    let registerPayload = {
      action: 'register',
      data: 'player'
    }

    dispatch('sendPayload', registerPayload)
  },

  disconnectFromServer ({ state }) {
    state.socket.close()
  },

  sendPayload ({ state }, payload) {
    payload.key = state.connectionKey
    if (state.socket) state.socket.send(JSON.stringify(payload));
  }
}

// mutations
const mutations = {
  setServerAddress (state, serverAddress) {
    state.serverAddress = serverAddress
  },

  setSocket (state, socket) {
    state.socket = socket
    state.isConnected = true
  },

  setConnectionKey (state, key) {
    state.connectionKey = key
  },

  disconnect (state) {
    state.isConnected = false
    state.socket = null
    state.connectionKey = 'null'
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}