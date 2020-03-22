<template>
  <div class="priorities-selector" @click="showPrioritiesToSelect">
    <div :class="item.priority" class="priority">
      {{item.priority}}
    </div>
    <div class="priorities" :class="{ 'not-displayed': !(currentDisplayedId === itemId) }">
      <div
        v-for="index in 5"
        :key="index"
        class="priority"
        :class="'p' + index"
        @click="changePriority"
      >
        {{"p" + index}}
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: "PrioritiesBoard",
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
        return "*" + this.item.itemId;
      }
    },
    methods: {
      showPrioritiesToSelect() {
        const currentDisplayedId = (this.itemId == this.displayedId) ? null : this.itemId;

        if (currentDisplayedId != this.displayedId) {
          this.displayedId = currentDisplayedId;
          this.$emit("update:displayedId", currentDisplayedId);
        }
      },
      changePriority(event) {
        this.displayedId = this.itemId;
        this.item.priority = event.target.innerText.toLowerCase();
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
  .priorities-selector {
    position: relative;
  }

  .priority {
    color: white;
    text-transform: uppercase;
    font-weight: bold;
    margin-top: 5px;
    margin-left: 5px;
    padding: 4px;
    padding-top: 7px;
    border-radius: 2px;
    cursor: pointer;
    border: 1px solid rgba(0, 114, 255, 0.1);
  }

  .priority:hover {
    border: 1px solid #0859bd;
  }

  .p1 {
    background-color: #db0f20;
  }

  .p2 {
    background-color: #ff8200;
  }

  .p3 {
    background-color: #FBC02D;
  }

  .p4 {
    background-color: #4CAF50;
  }

  .p5 {
    background-color: #0d83dd;
  }

  .priorities {
    background-color: white;
    position: absolute;
    top: 1px;
    left: 38px;
    display: flex;
    padding-right: 5px;
    border: 1px solid #0859bd;
    border-radius: 2px;
    z-index: 999;
  }

  .priorities > div {
    margin-top: 3px;
    margin-bottom: 3px;
  }

  .not-displayed {
    display: none;
  }
</style>
