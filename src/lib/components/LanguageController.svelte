<script lang="ts">
	import { setLocale, getLocale } from '$lib/paraglide/runtime';
	import { Globe } from 'lucide-svelte';

	const options = [
		{ code: 'en' as const, label: 'English' },
		{ code: 'pt-br' as const, label: 'Português (BR)' }
	];

	let details: HTMLDetailsElement;

	function choose(code: 'en' | 'pt-br') {
		setLocale(code);
		details.open = false;
	}
</script>

<details bind:this={details} class="group relative">
	<summary
		class="text-ink-soft hover:text-accent flex cursor-pointer list-none items-center gap-1.5 text-sm transition-colors [&::-webkit-details-marker]:hidden"
	>
		<Globe class="size-4" />
		<span class="font-mono">{getLocale()}</span>
	</summary>
	<ul
		class="border-rule bg-paper absolute top-full right-0 z-10 mt-2 min-w-40 border py-1 shadow-[3px_3px_0_0_var(--color-rule)]"
	>
		{#each options as option (option.code)}
			<li>
				<button
					type="button"
					onclick={() => choose(option.code)}
					class="text-ink hover:bg-accent-soft hover:text-accent block w-full px-3 py-1.5 text-left text-sm whitespace-nowrap transition-colors"
				>
					{option.label}
				</button>
			</li>
		{/each}
	</ul>
</details>
