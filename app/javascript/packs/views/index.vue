<template>
  <div class="screen-board">
    <message-error />
    <message-success />
    <project-panel :refBoards="refBoards" />

    <div class="boards">
      <div class="boards-top">
        <board
          type="priorities"
          title="Priorities this week"
          :class="{ 'board-margin': true }"
          ref="priorities"
        />
        <board
          type="confidences"
          title="OKR Confidence"
          ref="confidences"
          :objective="true"
        />
      </div>
      <div class="boards-bottom">
        <board
          type="next_projects"
          title="Next 4 weeks - Projects"
          :class="{ 'board-margin': true }"
          ref="next_projects"
          :refBoards="refBoards"
        />
        <board
          title="Health metrics"
          type="health_metrics"
          ref="health_metrics"
        />
      </div>
    </div>
  </div>
</template>

<script>
  import Board from "../components/Board.vue";
  import ProjectPanel from "../components/ProjectPanel.vue";
  import MessageError from "../components/MessageError.vue";
  import MessageSuccess from "../components/MessageSuccess.vue";

  export default {
    components: {
      Board,
      ProjectPanel,
      MessageError,
      MessageSuccess
    },
    computed: {
      refBoards() {
        return this.$refs;
      }
    }
  }
</script>

<style scoped>
  .screen-board {
    display: flex;
    flex-direction: column;
    width: 1200px;
    min-height: 750px;
    padding: 15px 40px;
    margin: 20px auto;
    border: 1px solid rgba(0, 114, 255, 0.6);
    box-shadow: 4px 4px 6px rgba(30, 60, 90, 0.1);
    background-color: rgba(0, 114, 255, 0.1);
  }

  .boards {
    display: flex;
    flex: 1;
    flex-direction: column;
    margin-top: 10px;
  }

  .boards-top {
    display: flex;
    flex-direction: row;
    flex: 1;
  }

  .boards-bottom {
    display: flex;
    flex-direction: row;
    flex: 1;
    margin-top: 10px;
  }
</style>
