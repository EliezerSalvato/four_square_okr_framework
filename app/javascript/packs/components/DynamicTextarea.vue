<template>
  <textarea
    v-model="item.content"
    @keyup.prevent="keyUp"
    :style="{ height: height + 'px' }"
    ref="textarea"
  ></textarea>
</template>

<script>
  export default {
    name: "DynamicTextarea",
    props: {
      item: {
        type: Object,
        required: true
      }
    },
    data() {
      return {
        height: 30
      }
    },
    methods: {
      keyUp(event) {
        const lines = event.target.value.split(/\r|\r\n|\n/).length;
        const height = (lines == 1) ? 30 : (16 * lines + 12);
        this.height = height;
      },
      focus() {
        this.$refs.textarea.focus();
      }
    }
  }
</script>

<style scoped>
  textarea {
    resize: none;
  }
</style>
