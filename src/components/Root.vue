<template>
  <div class="root">
    <h1>Live market data</h1>
    <div class="controls">
      <div class="controls-group">
        <label for="sel">ISIN:</label>
        <select id="sel" v-model="isin">
          <option value="">--select from list--</option>
          <option v-for="o in isinOptionList"
                  :key="o.isin"
                  :value="o.isin">
            {{ o.name }} - {{ o.isin }}
          </option>
        </select>
        <button type="button"
                :disabled="!isin"
                @click="subscribe(isin)">Subscribe</button>
      </div>
      <div class="controls-group" style="margin-left: 30px">
        <label for="inp">ISIN:</label>
        <input id="inp" type="text" v-model="isinText" placeholder="enter custom"/>
        <button type="button" :disabled="!isinText">Subscribe</button>
      </div>
    </div>
    <div class="data">
      <table>
        <tr>
          <th style="width: 400px">ISIN</th>
          <th style="width: 200px">Price</th>
          <th style="width: 130px"></th>
        </tr>
        <tr v-for="l in liveData" :key="l.isin">
          <td>{{ l.isin }}</td>
          <td>{{ l.price }}</td>
          <td></td>
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
import { WebSocketSubject } from 'rxjs/webSocket'
import ISINs from './Isins'

export default {
  name: 'Root',
  created () {
    this.isinOptionList = ISINs
    this.liveDataM = {}
    this.connectWs()
  },
  methods: {
    connectWs () {
      this.ws = new WebSocketSubject('ws://159.89.15.214:8080')
      this.ws.subscribe(
        (data) => { this.onData(data) },
        (err) => console.error(err),
        () => console.warn('Completed!')
      )
    },

    subscribe (isin) {
      const row = { isin }
      this.liveDataM[isin] = row
      this.ws.next({'subscribe': isin})
      this.isin = ''
      this.liveData = [ ...this.liveData, row ]
      this.isinOptionList = ISINs.filter(e => typeof this.liveDataM[e.isin] === 'undefined')
    },

    unsubscribe (isin) {

    },

    onData (data) {
      // console.info(data)
      const {isin, price} = data;
      this.liveData = this.liveData.map(l => l.isin === isin ? {...l, price} : l)
    }
  },
  data () {
    return {
      price: '',
      isin: '',
      isinText: '',
      isinOptionList: [],
      liveData: []
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

  .data table {
    border: 1px solid #ccc;
  }
</style>
