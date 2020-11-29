<template>

<v-app id="inspire">
    <v-app-bar
      app
      color="white"
      flat
      >
      <v-container 
        class="py-0 fill-height">
        <v-avatar
          class="mr-10"
          size="32">
          <v-img src="@/assets/crab.png" />
        </v-avatar>

        <v-btn
          disabled
          text
          color="indigo"
          class="mr-2">
          SOCKET CONTROL HUB
        </v-btn>

        <v-spacer></v-spacer>
        
        
        <v-btn
          v-if="serverConnected"
          fab
          dark
          small
          color="red"
          class="mr-1"
          @click="disconnectFromServer">
          STOP
        </v-btn>
        <v-btn
          v-if="!serverConnected"
          fab
          dark
          small
          color="green"
          class="mr-1"
          @click="connectToServer">
          GO
        </v-btn>


        <v-responsive max-width="260">
          <v-text-field
            :value="desiredServerAddress" 
            dense
            flat
            hide-details
            rounded
            outlined
            color="indigo"
            solo-inverted
            @input="updateServerAddress">
          </v-text-field>

        </v-responsive>

      </v-container>
    </v-app-bar>

    <v-main class="grey lighten-3">
      <v-container>
        <v-row>
          <v-col cols="4">
            <v-sheet>
              <v-list color="transparent">
                <v-list-item
                  v-for="link in links"
                  :key="link"
                  link>
                  <v-list-item-content>
                    <v-list-item-title>
                      {{ link }}
                    </v-list-item-title>
                  </v-list-item-content>
                </v-list-item>

              </v-list>
            </v-sheet>
          </v-col>

          <v-col>
            <v-sheet
              min-height="70vh"
              rounded="">
              <v-main
                class="ma-0 pa-0">
                <router-view>
                  
                </router-view>
              </v-main>
            </v-sheet>
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>

</template>

<script>


export default {
  name: 'App',
  components: {
   
  },

  computed: {
    serverAddress () {
      return this.$store.getters['WebsocketClient/serverAddress']
    },
    serverConnected () {
      return this.$store.getters['WebsocketClient/serverConnected']
    },
  },

  mounted: function (){
    this.desiredServerAddress = JSON.parse(JSON.stringify(this.serverAddress))
  },

  methods: {
    updateServerAddress (value) {
      console.log(value)
      this.$store.commit('WebsocketClient/setServerAddress', value)
    }, 

    connectToServer () {
      console.log("CONNECTING")
      this.$store.dispatch('WebsocketClient/connectToServer')
    },

    disconnectFromServer () {
      console.log("DISCONNECTING")
      this.$store.dispatch('WebsocketClient/disconnectFromServer')
    }
  },

  data: () => ({
      links: [
        'Websocket Hub',
        'Analytics'
      ],
      desiredServerAddress: ''
    }),
};
</script>
