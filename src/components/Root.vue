<template>
  <div class="root">
    {{ price }}
  </div>
</template>

<script>
import { WebSocketSubject } from 'rxjs/webSocket'

export default {
  name: 'Root',
  created () {
    const ws = new WebSocketSubject('ws://159.89.15.214:8080')
    ws.subscribe(
      (data) => {
        this.price = data.price
      },
      (err) => console.error(err),
      () => console.warn('Completed!')
    )
    ws.next({'subscribe': 'DE000BASF111'})
    console.log('here')
  },
  data () {
    return {
      msg: 'Streaming market data',
      price: ''
    }
  }
}
</script>

<style scoped>
</style>
