<template>
  <textarea
    v-model="item.content"
    @keyup.prevent="keyUp"
    :style="{ height: height + 'px' }"
    ref="textarea"
    rows="1"
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
      adjustHeight() {
        const textarea = this.$refs.textarea;
        textarea.style.cssText = "height: auto;";
        const scrollHeight = textarea.scrollHeight - 12;
        const lines = Math.round(scrollHeight / 16);
        const height = (lines == 1) ? this.height : (16 * lines + 12);
        textarea.style.cssText = "height:" + height + "px";
      },
      keyUp(event) {
        this.adjustHeight();
      },
      focus() {
        this.$refs.textarea.focus();
      }
    },
    mounted() {
      this.adjustHeight();
    }
  }
</script>

<style scoped>
  textarea {
    resize: none;
  }
</style>
