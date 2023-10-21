export async function fetchNui<T = any>(
  eventName: string,
  data?: any
): Promise<T> {
  const options = {
    method: "post",
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify(data),
  };

  const resourceName = (window as any).GetParentResourceName
    ? (window as any).GetParentResourceName()
    : "nui-frame-app";

  return fetch(`https://${resourceName}/${eventName}`, options)
    .then((resp) => {
      if (!resp.ok) {
        throw new Error(`Failed to fetch: ${resp.status} - ${resp.statusText}`);
      }
      return resp.json();
    })
    .catch((error) => {
      return null;
    });
}
