<template>
  <div class="annotations">
    <div class="annotations-icon"
      :class="{ 'has-annotations': annotationsLength() > 0 }"
      @click="showHideAnnotations"
    >
      <vue-fontawesome icon="edit" size="1.3" />
    </div>
    <div class="annotations-text" :class="{ 'not-displayed': !(currentDisplayedId === itemId) }">
      <textarea v-model="item.annotations" ref="annotation"></textarea>
    </div>
  </div>
</template>

<script>
  export default {
    name: "AnnotationsSelector",
    props: {
      item: {
        type: Object,
        required: true
      },
      currentDisplayedId: String
    },
    data() {
      return {
        displayedId: null
      }
    },
    computed: {
      itemId() {
        return "**" + this.item.itemId;
      }
    },
    methods: {
      showHideAnnotations() {
        const currentDisplayedId = (this.itemId == this.displayedId) ? null : this.itemId;

        if (currentDisplayedId != this.displayedId) {
          this.displayedId = currentDisplayedId;
          this.$emit("update:displayedId", currentDisplayedId);
          this.$setFocus(this.$refs.annotation);
        }
      },
      annotationsLength() {
        return (this.item.annotations || "").length;
      }
    },
    watch: {
      currentDisplayedId(newValue, _oldValue) {
        this.displayedId = newValue;
      }
    }
  }
</script>

<style scoped>
  .annotations {
    position: relative;
  }

  .annotations-icon {
    width: 30px;
    height: 30px;
    background-size: contain;
    padding-top: 12px;
    padding-left: 5px;
    margin-right: -5px;
    cursor: pointer;
    color: rgba(0, 114, 255, 0.7);
  }

  .annotations-icon:hover {
    color: rgba(0, 114, 255, 0.99);
  }

  .has-annotations {
    color: rgba(255, 130, 0, 0.8);
  }

  .has-annotations:hover {
    color: rgb(255, 130, 0);
  }

  .annotations-text {
    position: absolute;
    top: 36px;
    left: 0;
    z-index: 999;
    background-color: rgba(0, 114, 255, 0.8);
    border-radius: 2px;
    padding-right: 4px;
    margin-left: 2px;
  }

  .annotations-text textarea {
    width: 475px;
    height: 92px;
    resize: none;
  }

  .not-displayed {
    display: none;
  }
</style>
