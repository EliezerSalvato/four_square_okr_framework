<template>
  <div :class="{ active: showMessageSuccess }">
     <vue-fontawesome icon="info-circle" />
    {{text}}
    <a class="close" @click="close">
      <vue-fontawesome icon="times" />
    </a>
  </div>
</template>

<script>
  import { mapState, mapActions } from "vuex";

  export default {
    name: "MessageSuccess",
    props: {
      customText: String
    },
    computed: {
      ...mapState(["showMessageSuccess", "textMessageSuccess"]),
      text() {
        return this.textMessageSuccess || this.customText || "Successfully saved.";
      }
    },
    watch: {
      showMessageSuccess(newValue) {
        if (newValue) {
          setTimeout(() => {
            this.close();
          }, 2000);
        }
      }
    },
    methods: {
      ...mapActions(["setShowMessageSuccess"]),
      close() {
        this.setShowMessageSuccess(false);
        this.$emit("closed");
      }
    }
  }
</script>

<style scoped>
  div {
    border: 1px solid #c3e6cb;
    background-color: rgba(212, 237, 218, 0.95);
    color: #155724;
    width: 500px;
    height: 50px;
    display: none;
    padding-left: 10px;
    align-items: center;
    border-radius: .25rem;
    margin: 4px auto;
    position: absolute;
    left: 0;
    right: 0;
  }

  div.active {
    display: flex;
    animation: fadeInDown 0.3s;
  }

  i {
    margin-top: -3px;
    margin-right: 5px;
  }

  .close {
    float: right;
    line-height: 1;
    color: #000;
    text-shadow: 0 1px 0 #fff;
    opacity: .5;
    font-family: 'Cabin';
    margin-left: auto;
    cursor: pointer;
  }

  .close:hover {
    opacity: 0.75;
  }

  @keyframes fadeInDown {
    from {
      transform: translate3d(0, -30px, 0);
      opacity: 0;
    }
    to {
      transform: translate3d(0, 0, 0);
      opacity: 1;
    }
  }
</style>
