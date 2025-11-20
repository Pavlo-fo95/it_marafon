async function readErrorBody(res: Response): Promise<string> {
  const raw = await res.text().catch(() => "");
  if (!raw) return "";

  try {
    const j = JSON.parse(raw) as Record<string, unknown>;
    const title = typeof j.title === "string" ? j.title : undefined;
    const message = typeof j.message === "string" ? j.message : undefined;
    const error = typeof j.error === "string" ? j.error : undefined;
    return title || message || error || raw;
  } catch {
    return raw;
  }
}

export async function apiDelete(
  url: string,
  init?: RequestInit,
): Promise<void> {
  const res = await fetch(url, { method: "DELETE", ...(init ?? {}) });

  if (res.ok || res.status === 204) return;

  const details = await readErrorBody(res);
  throw new Error(
    `HTTP ${res.status} ${res.statusText}${details ? ` — ${details}` : ""}`,
  );
}

export async function apiGet<T>(url: string, init?: RequestInit): Promise<T> {
  const res = await fetch(url, { method: "GET", ...(init ?? {}) });

  if (!res.ok) {
    const details = await readErrorBody(res);
    throw new Error(
      `HTTP ${res.status} ${res.statusText}${details ? ` — ${details}` : ""}`,
    );
  }

  if (res.status === 204) return undefined as unknown as T;
  return (await res.json()) as T;
}

// 🔹 Новый helper для POST
export async function apiPost<TResponse, TBody = unknown>(
  url: string,
  body?: TBody,
  init?: RequestInit,
): Promise<TResponse> {
  const res = await fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      ...(init?.headers ?? {}),
    },
    body: body !== undefined ? JSON.stringify(body) : init?.body,
    ...(init ?? {}),
  });

  if (!res.ok) {
    const details = await readErrorBody(res);
    throw new Error(
      `HTTP ${res.status} ${res.statusText}${details ? ` — ${details}` : ""}`,
    );
  }

  if (res.status === 204) return undefined as unknown as TResponse;
  return (await res.json()) as TResponse;
}

// 🔹 Новый helper для PUT
export async function apiPut<TResponse, TBody = unknown>(
  url: string,
  body?: TBody,
  init?: RequestInit,
): Promise<TResponse> {
  const res = await fetch(url, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json",
      ...(init?.headers ?? {}),
    },
    body: body !== undefined ? JSON.stringify(body) : init?.body,
    ...(init ?? {}),
  });

  if (!res.ok) {
    const details = await readErrorBody(res);
    throw new Error(
      `HTTP ${res.status} ${res.statusText}${details ? ` — ${details}` : ""}`,
    );
  }

  if (res.status === 204) return undefined as unknown as TResponse;
  return (await res.json()) as TResponse;
}
