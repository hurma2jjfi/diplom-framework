<template>
    <main>
        <FirstSectionComponent />
        <SectionSecondComponent />
    </main>
</template>

<script>
import FirstSectionComponent from '../../components/main/SectionFirstComponent.vue';
import SectionSecondComponent from '../../components/main/SectionSecondComponent.vue';


export default {
    components: {
        FirstSectionComponent, SectionSecondComponent
    }
}

</script>

<style>

</style>