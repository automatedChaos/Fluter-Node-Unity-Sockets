import index from './components/index';
import about from './components/about';
import help from './components/help';

import Vue from 'vue'
import App from './App.vue'
import Vuex from 'vuex'
import vuetify from './plugins/vuetify';
import VueRouter from 'vue-router'

import store from './store'

Vue.config.productionTip = false

Vue.use(VueRouter)
Vue.use(Vuex)

const routes = [
  { path: '/index', component: index },
  { path: '/about', component: about },
  { path: '/help', component: help }
]

const router = new VueRouter({
  routes // short for `routes: routes`
})

new Vue({
  router,
  vuetify,
  store,
  render: h => h(App)
}).$mount('#app')
