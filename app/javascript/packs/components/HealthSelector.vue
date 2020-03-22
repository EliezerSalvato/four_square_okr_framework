<template>
  <div class="health-selector" @click="showHealthToSelect">
    <div :class="item.health" class="health"></div>
    <div class="health-list" :class="{ 'not-displayed': !(currentDisplayedId === itemId) }">
      <div
        v-for="health in healthTypes"
        :key="health"
        class="health"
        :class="health"
        @click="changeHealth"
      >
        {{health}}
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: "HealthSelector",
    props: {
      item: {
        type: Object,
        required: true
      },
      currentDisplayedId: String
    },
    data() {
      return {
        displayedId: null,
        healthTypes: ["happy", "sad", "attention"]
      }
    },
    computed: {
      itemId() {
        return "*" + this.item.itemId;
      }
    },
    methods: {
      showHealthToSelect() {
        const currentDisplayedId = (this.itemId == this.displayedId) ? null : this.itemId;

        if (currentDisplayedId != this.displayedId) {
          this.displayedId = currentDisplayedId;
          this.$emit("update:displayedId", currentDisplayedId);
        }
      },
      changeHealth(event) {
        this.displayedId = this.itemId;
        this.item.health = event.target.innerText;
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
  .health-selector {
    position: relative;
  }

  .health {
    margin-top: 5px;
    margin-left: 5px;
    cursor: pointer;
    height: 32px;
    width: 32px;
    text-indent: -999px;
    overflow: hidden;
  }

  .health-list {
    background-color: white;
    position: absolute;
    top: 1px;
    left: 38px;
    display: flex;
    padding-right: 5px;
    padding-bottom: 2px;
    border: 1px solid #0859bd;
    border-radius: 2px;
  }

  .health-list .health {
    margin-top: 3px;
  }

  .happy {
    background: url("../assets/happy.png") no-repeat center center;
    background-size: contain;
  }

  .sad {
    background: url("../assets/sad.png") no-repeat center center;
    background-size: contain;
  }

  .attention {
    background: url("../assets/attention.png") no-repeat center center;
    background-size: contain;
  }

  .not-displayed {
    display: none;
  }
</style>
