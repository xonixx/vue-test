<template>
  <div class="root">
    <div class="controls">
      <select v-model="isin">
        <option v-for="r in ISINs"
                :key="r.isin"
                value="r.isin">
          {{ r.name }} - {{ r.isin }}
        </option>
      </select>
      <input type="text" v-model="isinText"/>
    </div>
    {{ price }}
  </div>
</template>

<script>
import { WebSocketSubject } from 'rxjs/webSocket'
import ISINs from './Isins'

export default {
  name: 'Root',
  created () {
    this.ISINs = ISINs
    this.connectWs()
  },
  methods: {
    connectWs () {
      this.ws = new WebSocketSubject('ws://159.89.15.214:8080')
      this.ws.subscribe(
        (data) => {
          console.info(data)
          this.price = data.price
        },
        (err) => console.error(err),
        () => console.warn('Completed!')
      )
      // ws.next({'subscribe': 'DE000BASF111'})
      // ws.next({'subscribe': 'AAA'})
    }
  },
  data () {
    return {
      price: '',
      isin: '',
      isinText: '',
      ISINs: []
    }
  }
}
</script>

<style scoped>
</style>
