<template>

  <v-container>

    <div>
      SERVER: 
      <span :class="serverConnected ? 'green--text' : 'red--text'"> 
        {{ serverAddress }} 
      </span>
    </div>
    
    <div>
      CLIENT KEY: 
      <span :class="serverConnected ? 'green--text' : 'red--text'"> 
        {{ connectionKey }} 
      </span>
    </div>

    <center>
      <v-img 
        src="@/assets/phone.svg"
        height="400"
        width="300"
        contain
        class="mt-3 pt-8 white--text">
        
        <v-container 
          class="ma-0 pa-0">
          
          <v-row
            no-gutters 
            class="ma-0 pa-0 mb-8 mt-3">
            <v-col
              class=""
              sm="6"
              offset-sm="3">
              <v-card
                align="center"
                class="ma-0 pa-0"
                outlined
                tile>
                DEBUG CONTROLS
              </v-card>
            </v-col>
          </v-row>

          <v-row
            no-gutters 
            class="ma-0 pa-0 mb-3 mt-3">
            
            <v-col
              class=""
              sm="4"
              offset-sm="4">
              <v-btn
                width="100%"
                color="secondary"
                @click="sendData ('0,1')">
                FORWARDS
              </v-btn>
            </v-col>

          </v-row>

          <v-row
            no-gutters 
            class="ma-0 pa-0 mb-3 mt-3">
            
            <v-col
              class=""
              sm="3"
              offset-sm="3">
              <v-btn
                color="secondary"
                @click="sendData ('-1,0')">
                LEFT
              </v-btn>
            </v-col>

            <v-col
              class=""
              sm="3">
              <v-btn
                color="secondary"
                @click="sendData ('1,0')">
                RIGHT
              </v-btn>
            </v-col>

          </v-row>

          <v-row
            no-gutters 
            class="ma-0 pa-0 mb-8 mt-3">
            
            <v-col
              class=""
              sm="4"
              offset-sm="4">
              <v-btn
                width="100%"
                color="secondary"
                @click="sendData ('0,-1')">
                BACKWARDS
              </v-btn>
            </v-col>
          </v-row>
          
          <v-row
            no-gutters 
            class="ma-0 pa-0 mb-3 mt-3">
            
            <v-col
              class=""
              sm="4"
              offset-sm="4">
              <v-btn
                width="100%"
                color="secondary"
                @click="sendData ('JUMP')">
                JUMP
              </v-btn>
            </v-col>

          </v-row>
        </v-container>
      </v-img>
    </center>
  </v-container>
</template>

<script>
  export default {
    computed: {
      serverAddress () {
        return this.$store.getters['WebsocketClient/serverAddress']
      },

      serverConnected () {
        return this.$store.getters['WebsocketClient/serverConnected']
      },

      connectionKey () {
        return this.$store.getters['WebsocketClient/connectionKey']
      }
    },
    data: () => ({
    
    }),

    methods: {
      sendData (command) {
        console.log(command)
        
        let payload = {
          action: 'player-position',
          data: command
        }
        this.$store.dispatch('WebsocketClient/sendPayload', payload)
      }
    }
  }
</script>