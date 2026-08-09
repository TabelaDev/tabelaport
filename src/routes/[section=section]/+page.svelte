<script lang="ts">
	import { page } from '$app/state';
	import AboutGrid, { type AboutItem } from '$lib/components/AboutGrid.svelte';
	import ExperienceGrid from '$lib/components/ExperienceGrid.svelte';
	import { getSection } from '$lib/data/sections';
	import { getLocaleData } from '$lib/data/paraglide-adapter';
	import type { Experience } from '$lib/interfaces/experience';

	const section = $derived(getSection(page.params.section ?? ''));
	const items = $derived(section ? getLocaleData(section.feature) : []);
</script>

{#if section?.type === 'cards'}
	<AboutGrid items={items as AboutItem[]} />
{:else}
	<ExperienceGrid experiences={items as Experience[]} />
{/if}
