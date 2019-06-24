<template>
  <div id="app">
    <div>
      <h3>Learn "like"</h3>
      <input v-on:keyup.enter="like" type="text" size=80 v-model="likeUrl" placeholder="URL">
      <br>
      <pre>{{ likeLog }}</pre>
    </div>
    <div>
      <h3>Learn "dislike"</h3>
      <input v-on:keyup.enter="dislike" type="text" size=80 v-model="dislikeUrl" placeholder="URL">
      <br>
      <pre>{{ dislikeLog }}</pre>
    </div>
    <div>
      <h3>Classify</h3>
      <input v-on:keyup.enter="classify" type="text" size=80 v-model="classifyUrl" placeholder="URL">
      <pre>{{ log }}</pre>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'App',
  data: function () {
    return {
      log: '',
      likeLog: '',
      dislikeLog: '',
      likeUrl: '',
      dislikeUrl: '',
      classifyUrl: ''
    }
  },
  methods: {
    like: function (event) {
      let me = this
      let params = new URLSearchParams()
      params.append('key', 'TEST')
      params.append('class', 'Like')
      params.append('url', me.likeUrl)
      axios.post('/learn', params)
        .then(function (response) {
          me.likeLog = `${me.likeUrl}: ${response.data}`
          me.likeUrl = ''
        })
    },
    dislike: function (event) {
      let me = this
      let params = new URLSearchParams()
      params.append('key', 'TEST')
      params.append('class', 'Dislike')
      params.append('url', me.dislikeUrl)
      axios.post('/learn', params)
        .then(function (response) {
          me.dislikeLog = `${me.dislikeUrl}: ${response.data}`
          me.dislikeUrl = ''
        })
    },
    classify: function (event) {
      let me = this
      let params = new URLSearchParams()
      params.append('key', 'TEST')
      params.append('url', me.classifyUrl)
      axios.post('/classify', params)
        .then(function (response) {
          me.log += `${me.classifyUrl}: ${JSON.stringify(response.data)}\n`
          me.classifyUrl = ''
        })
    }
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  /* text-align: center; */
  color: #2c3e50;
  margin: 10px;
}
</style>
