<template>
  <div class="confidence-selector">
    <select v-model="item.confidence" name="confidence">
      <option v-for="index in 10" :key="index" :value="index">
        {{index + "/10"}}
      </option>
    </select>
  </div>
</template>

<script>
  export default {
    name: "ConfidenceSelector",
    props: {
      item: {
        type: Object,
        required: true
      }
    }
  }
</script>

<style scoped>
  select {
    width: 68px;
  }
</style>
