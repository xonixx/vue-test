<template>
  <div class="root">
    <h1>Live market data</h1>
    <div class="controls">
      <div class="controls-group">
        <label for="sel">ISIN:</label>
        <select id="sel" v-model="isin">
          <option value="">--select from list--</option>
          <option v-for="r in isinOptionList"
                  :key="r.isin"
                  value="r.isin">
            {{ r.name }} - {{ r.isin }}
          </option>
        </select>
        <button type="button" :disabled="!isin">Subscribe</button>
      </div>
      <div class="controls-group" style="margin-left: 30px">
        <label for="inp">ISIN:</label>
        <input id="inp" type="text" v-model="isinText" placeholder="enter custom"/>
        <button type="button" :disabled="!isinText">Subscribe</button>
      </div>
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
    this.isinOptionList = ISINs
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
      isinOptionList: []
    }
  }
}
</script>

<style scoped>
  .controls-group {
    /*border: 1px solid #ccc;*/
    padding: 5px;
    display: inline-block;
  }
</style>
