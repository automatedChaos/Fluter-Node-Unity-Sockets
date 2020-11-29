  
import Vue from 'vue'
import Vuex from 'vuex'
import WebsocketClient from './modules/WebsocketClient'

Vue.use(Vuex)

const debug = process.env.NODE_ENV !== 'production'

export default new Vuex.Store({
  modules: {
    WebsocketClient
  },
  strict: debug,
})