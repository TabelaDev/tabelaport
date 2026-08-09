// Tipos mínimos para o `async_hooks` usado pelo paraglide gerado
// (`src/lib/paraglide/server.js` faz `import("async_hooks")`).
// O runtime é Cloudflare Workers com `nodejs_compat`, então o módulo existe;
// só faltava a declaração de tipos (o projeto não usa @types/node de propósito,
// pra não expor globals Node no ambiente Workers).
declare module 'async_hooks' {
	export class AsyncLocalStorage<T = unknown> {
		getStore(): T | undefined;
		run<R>(store: T, callback: (...args: unknown[]) => R, ...args: unknown[]): R;
		disable(): void;
		enable(): void;
		enterWith(store: T): void;
	}
}
