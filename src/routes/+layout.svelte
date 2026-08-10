<script lang="ts">
	import { page } from '$app/state';
	import { getLocale, locales, localizeHref } from '$lib/paraglide/runtime';
	import './layout.css';
	import favicon from '$lib/assets/favicon.svg';
	import Navbar from '$lib/components/Navbar.svelte';
	import { pageTitle, siteDescription, siteTitle } from '$lib/seo';

	let { children } = $props();

	// The site shipped without a <title> or a description, so a shared link
	// rendered as a bare URL. Derived, so it follows the active locale.
	const title = $derived(pageTitle(page.url.pathname));
	const description = $derived(siteDescription());
	const canonical = $derived(new URL(page.url.pathname, page.url.origin).href);
</script>

<svelte:head>
	<link rel="icon" href={favicon} />
	<title>{title}</title>
	<meta name="description" content={description} />
	<link rel="canonical" href={canonical} />

	<!-- One alternate per locale, so a crawler finds both versions of a page. -->
	{#each locales as locale (locale)}
		<link
			rel="alternate"
			hreflang={locale}
			href={new URL(localizeHref(page.url.pathname, { locale }), page.url.origin).href}
		/>
	{/each}

	<meta property="og:type" content="website" />
	<meta property="og:site_name" content={siteTitle()} />
	<meta property="og:locale" content={getLocale()} />
	<meta property="og:title" content={title} />
	<meta property="og:description" content={description} />
	<meta property="og:url" content={canonical} />
	<meta name="twitter:card" content="summary" />
	<meta name="twitter:title" content={title} />
	<meta name="twitter:description" content={description} />
</svelte:head>

<div class="flex min-h-screen flex-col">
	<Navbar />
	<main class="mx-auto w-full max-w-5xl flex-1 px-5 py-10 sm:px-8 sm:py-14 lg:px-10">
		{@render children()}
	</main>
</div>

<div style="display:none">
	{#each locales as locale}
		<a href={localizeHref(page.url.pathname, { locale })}>
			{locale}
		</a>
	{/each}
</div>
