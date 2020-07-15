<template>
  <div class="board">
    <div class="board-header">
      {{title}}
      <input type="button" class="add" @click.prevent="addItem()" />
    </div>
    <ul>
      <li v-if="objective" class="objective">
        <span>Objective:</span> {{ selectedStep && selectedStep.objective }}
      </li>
      <Draggable v-model="items" :group="type" @end="reorder">
        <li class="board-items" v-for="(item, index) in items" :key="item.id">
          <priorities-selector
            v-if="type === 'priorities'"
            :item="item"
            :currentDisplayedId="currentDisplayedId"
            @update:displayedId="currentDisplayedId = $event"
          />
          <annotations-selector
            v-if="type === 'priorities'"
            :item="item"
            :currentDisplayedId="currentDisplayedId"
            @update:displayedId="currentDisplayedId = $event"
          />
          <confidence-selector
            v-if="type === 'confidences'"
            :item="item"
          />
          <add-priority-selector
            v-if="type === 'next_projects'"
            :item="item"
            :refPriorities="refBoards.priorities"
            @remove:next_project="removeItem(getIndex($event))"
          />
          <health-selector
            v-if="type === 'health_metrics'"
            :item="item"
            :currentDisplayedId="currentDisplayedId"
            @update:displayedId="currentDisplayedId = $event"
          />
          <dynamic-textarea :item="item" :ref="item.itemId" />
          <input type="button" class="remove" @click.prevent="removeItem(index)" />
        </li>
      </Draggable>
    </ul>
  </div>
</template>

<script>
  import { api } from "../services.js";
  import { mapState, mapActions } from "vuex";
  import Draggable from 'vuedraggable';
  import PrioritiesSelector from "../components/PrioritiesSelector.vue";
  import AnnotationsSelector from "../components/AnnotationsSelector.vue";
  import ConfidenceSelector from "../components/ConfidenceSelector.vue";
  import AddPrioritySelector from "../components/AddPrioritySelector.vue";
  import HealthSelector from "../components/HealthSelector.vue";
  import DynamicTextarea from "../components/DynamicTextarea.vue";

  export default {
    name: "Board",
    props: {
      type: {
        type: String,
        required: true
      },
      title: {
        type: String,
        required: true
      },
      objective: {
        type: Boolean,
        default: false
      },
      refBoards: Object
    },
    components: {
      PrioritiesSelector,
      AnnotationsSelector,
      ConfidenceSelector,
      AddPrioritySelector,
      HealthSelector,
      DynamicTextarea,
      Draggable
    },
    data() {
      return {
        items: null,
        unwatch: null,
        finishedLoad: false,
        currentDisplayedId: null
      }
    },
    computed: mapState(["selectedStep", "newProjectStep"]),
    methods: {
      ...mapActions(
        ["projectStepChanged", "updateItems"]
      ),
      getItems(project_step_id) {
        return api.get(`project_steps/${project_step_id}/${this.type}`).then(response => {
          const items = response.data.map(item => ({ ...item, itemId: item.id }));
          this.items = items;
        });
      },
      getItem(itemId) {
        return this.items.find(item => item.itemId === itemId);
      },
      addItem(content = '') {
        const itemId = new Date().getTime();
        const item = { itemId: itemId, id: null, content: content };

        switch (this.type) {
          case 'priorities': item.priority = "p1"; break;
          case 'health_metrics': item.health = "happy"; break;
          case 'confidences': item.confidence = "5"; break;
        }

        this.items.push(item);
        this.$setFocusByRefId(this.$refs, itemId);
        this.reorder();
      },
      getIndex(item) {
        return this.items.indexOf(item);
      },
      removeItem(index) {
        this.items.splice(index, 1);
        this.reorder();
      },
      reorder() {
        const items = this.items.map((item, index) => ({ ...item, order: index }));
        this.items = items;
      }
    },
    watch: {
      selectedStep(newValue) {
        this.finishedLoad = false;

        if (isNaN(newValue.id)) {
          this.items = null;
        } else {
          this.getItems(newValue.id);
        }
      },
      "selectedStep.id"(newValue) {
        if (this.finishedLoad && !this.newProjectStep) {
          this.finishedLoad = false;

          if (newValue === null) {
            this.items = null;
          } else {
            this.getItems(newValue);
          }
        }
      },
      items: {
        deep: true,
        handler() {
          if (this.finishedLoad) {
            this.projectStepChanged(true);
          }

          this.updateItems({ type: this.type, items: this.items });

          this.finishedLoad = true;
        }
      }
    }
  }
</script>

<style scoped>
  .board {
    display: flex;
    flex-direction: column;
    flex: 1;
    background-color: rgba(0, 114, 255, 0.3);
    border-radius: 4px;
    padding-bottom: 5px;
  }

  .board-margin {
    margin-right: 10px;
  }

  .board-header {
    display: flex;
    flex-direction: row;
    justify-content: center;
    padding: 5px;
    padding-bottom: 9px;
    background-color: rgba(0, 114, 255, 0.8);
    color: white;
    border-radius: 4px;
    align-items: center;
  }

  .board-items {
    display: flex;
    flex-direction: row;
    flex: 1;
    margin-right: 5px;
  }

  .add {
    margin-left: auto;
  }

  .objective {
    margin: 5px;
  }

  .objective span {
    color: white;
    font-weight: bold;
  }
</style>
