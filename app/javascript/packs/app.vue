<template>
  <div id="template">
    <app-header />

    <main id="main">
      <transition mode="out-in">
        <router-view />
      </transition>
    </main>

    <app-footer />
  </div>
</template>

<script>
  import AppHeader from "./components/AppHeader.vue";
  import AppFooter from "./components/AppFooter.vue";

  export default {
    components: {
      AppHeader,
      AppFooter
    }
  }
</script>

<style>
  * {
    box-sizing: border-box;
  }

  body, ul, li, h1, h2, p {
    padding: 0px;
    margin: 0px;
  }

  body {
    font-family: Helvetica, Arial, sans-serif;
    color: #345;
    background: url("./assets/background.svg") repeat top;
  }

  ul {
    list-style: none;
  }

  a {
    text-decoration: none;
  }

  img {
    max-width: 100%;
    display: block;
  }

  #template {
    display: flex;
    min-height: 100vh;
    flex-direction: column;
  }

  #main {
    flex: 1;
  }

  .btn {
    display: block;
    padding: 10px 30px;
    background: #0072ff;
    border-radius: 4px;
    color: #fff;
    text-align: center;
    font-size: 1rem;
    box-shadow: 0 4px 8px rgba(30, 60, 90, 0.2);
    transition: all 0.3s;
    border: none;
    font-family: Helvetica, Arial, sans-serif;
    cursor: pointer;
    height: 37px;
  }

  .btn:hover {
    background: #0859bd;
    transform: scale(1.1);
  }

  .btn-disabled, .btn-disabled:hover {
    background: rgba(247, 247, 247, 0.2);
    transform: scale(1);
    cursor: initial;
  }

  .btn-remove {
    width: 35px;
    font-weight: bold;
    font-size: 1.1em;
    background-color: #dc3545;
    color: white;
    border: none;
    cursor: pointer;
  }

  .btn-remove:hover {
    transform: scale(1.1);
    border: none;
  }

  .btn-remove-disabled, .btn-remove-disabled:hover {
    background: rgba(247, 247, 247, 0.2);
    transform: scale(1);
    cursor: initial;
  }

  input, textarea {
    border-radius: 2px;
    border: 1px solid white;
    padding: 5px;
    box-shadow: 0 4px 8px rgba(30, 60, 90, 0.1);
    transition: all 0.3s;
    font-size: 0.9rem;
    font-family: Helvetica, Arial, sans-serif;
    margin-top: 5px;
    margin-left: 5px;
    width: 100%;
    height: 30px;
  }

  input:hover, input:focus, textarea:hover, textarea:focus {
    outline: none;
    box-shadow: 0 6px 12px rgba(30, 60, 90, 0.2);
    border-color: #0859bd;
  }

  .add {
    background: url("./assets/add.svg") no-repeat center center;
    border: none;
    box-shadow: none;
    width: 30px;
    cursor: pointer;
    overflow: hidden;
    margin-left: 2px;
  }

  .add:hover {
    box-shadow: none;
    background: url("./assets/add-hover.svg") no-repeat center center;
  }

  .remove {
    background: url("./assets/remove.svg") no-repeat center center;
    border: none;
    box-shadow: none;
    width: 30px;
    cursor: pointer;
    overflow: hidden;
    margin-left: 2px;
  }

  .remove:hover {
    box-shadow: none;
    background: url("./assets/remove-hover.svg") no-repeat center center;
  }

  select {
    border-radius: 2px;
    border: 1px solid rgba(247, 247, 247, 0.9);
    padding: 5px;
    box-shadow: 0 4px 8px rgba(30, 60, 90, 0.1);
    transition: all 0.3s;
    font-size: 0.9rem;
    font-family: Helvetica, Arial, sans-serif;
    margin-top: 5px;
    margin-left: 5px;
    width: 100%;
    background-color: rgba(247, 247, 247, 0.9);
  }

  select:hover, select:focus {
    outline: none;
    box-shadow: 0 6px 12px rgba(30, 60, 90, 0.2);
    border-color: #0859bd;
  }

  .v-enter, .v-leave-to {
    opacity: 0;
  }

  .v-enter {
    transform: translate3d(0, -20px, 0);
  }

  .v-leave-to {
    transform: translate3d(0, 20px, 0);
  }

  .v-enter-active, .v-leave-active {
    transition: all 0.3s;
  }

  .vfc-styles-conditional-class {
    margin: 0 !important;
    padding: 0 !important;
  }

  .vfc-styles-conditional-class input.vfc-single-input {
    border-radius: 2px !important;
    border: 1px solid white !important;
    padding: 5px !important;
    box-shadow: 0 4px 8px rgba(30, 60, 90, 0.1) !important;
    transition: all 0.3s !important;
    font-size: 0.9rem !important;
    font-family: Helvetica, Arial, sans-serif !important;
    margin-top: 5px !important;
    margin-left: 5px !important;
    width: 100px !important;
    height: 30px;
  }

  .vfc-styles-conditional-class input.vfc-single-input:hover,
  .vfc-styles-conditional-class input.vfc-single-input:focus {
    outline: none !important;
    box-shadow: 0 6px 12px rgba(30, 60, 90, 0.2) !important;
    border-color: #0859bd !important;
  }

  .log-in {
    width: 600px;
    margin: 250px auto;
    border: 1px solid #0859bd;
    padding: 50px;
    border-radius: 4px;
  }
</style>
