export default async function request(input: RequestInfo, init?: RequestInit) {
  const response = await fetch(input, init);
  if (!response.ok) {
    throw new Error('Network response was not ok');
  }
  return response.json();
}
