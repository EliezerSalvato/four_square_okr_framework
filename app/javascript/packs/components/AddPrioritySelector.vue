<template>
  <div class="add-priority" @click="AddItemToPriority">
    <vue-fontawesome icon="arrow-up" size="1.3" />
  </div>
</template>

<script>
  export default {
    name: "AddPrioritySelector",
    props: {
      item: {
        type: Object,
        required: true
      },
      refPriorities: Object
    },
    methods: {
      AddItemToPriority() {
        this.$emit("remove:next_project", this.item);
        this.refPriorities.addItem(this.item.content);
      }
    }
  }
</script>

<style scoped>
  .add-priority {
    width: 30px;
    height: 30px;
    background-size: contain;
    padding-top: 10px;
    padding-left: 5px;
    margin-right: -3px;
    cursor: pointer;
    color: rgba(0, 114, 255, 0.7);
  }

  .add-priority:hover {
    color: rgba(0, 114, 255, 0.99);
  }
</style>
