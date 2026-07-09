/**
 * Weather App Backend
 * -----------------------------------------------------------
 * A lightweight Express proxy/cache server sitting in front of
 * the OpenWeatherMap API. It exists so that:
 *   1. Your OpenWeatherMap API key never ships inside the mobile app.
 *   2. Repeated requests for the same city are cached in-memory,
 *      cutting down external API calls and speeding up responses.
 *   3. You get a clean, normalized JSON response tailored for the
 *      Flutter frontend (current weather + hourly + daily forecast).
 * -----------------------------------------------------------
 */

require('dotenv').config();
const express = require('express');
const cors = require('cors');
const axios = require('axios');
const NodeCache = require('node-cache');
const rateLimit = require('express-rate-limit');

const app = express();
const PORT = process.env.PORT || 5000;
const API_KEY = process.env.OPENWEATHER_API_KEY;
const CACHE_TTL = parseInt(process.env.CACHE_TTL || '600', 10);

const cache = new NodeCache({ stdTTL: CACHE_TTL, checkperiod: 120 });

app.use(cors());
app.use(express.json());

// Basic rate limiting to protect the free-tier OpenWeatherMap quota
const limiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 60, // 60 requests per minute per IP
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: 'Too many requests, please slow down.' },
});
app.use('/api/', limiter);

const BASE_URL = 'https://api.openweathermap.org/data/2.5';
const GEO_URL = 'https://api.openweathermap.org/geo/1.0';

// ---------- Helpers ----------

function requireApiKey(res) {
  if (!API_KEY || API_KEY === 'your_openweathermap_api_key_here') {
    res.status(500).json({
      error:
        'Server misconfiguration: OPENWEATHER_API_KEY is missing. Add it to backend/.env',
    });
    return false;
  }
  return true;
}

function normalizeCurrent(data) {
  return {
    city: data.name,
    country: data.sys?.country,
    coord: data.coord,
    tempC: data.main?.temp,
    feelsLikeC: data.main?.feels_like,
    tempMinC: data.main?.temp_min,
    tempMaxC: data.main?.temp_max,
    humidity: data.main?.humidity,
    pressure: data.main?.pressure,
    windSpeed: data.wind?.speed,
    windDeg: data.wind?.deg,
    clouds: data.clouds?.all,
    visibility: data.visibility,
    sunrise: data.sys?.sunrise,
    sunset: data.sys?.sunset,
    timezone: data.timezone,
    dt: data.dt,
    condition: data.weather?.[0]?.main,
    description: data.weather?.[0]?.description,
    icon: data.weather?.[0]?.icon,
  };
}

function normalizeForecast(data) {
  // OpenWeatherMap "forecast" endpoint returns 3-hour steps for 5 days.
  const hourly = data.list.slice(0, 8).map((item) => ({
    dt: item.dt,
    tempC: item.main.temp,
    condition: item.weather?.[0]?.main,
    icon: item.weather?.[0]?.icon,
    pop: item.pop, // probability of precipitation
  }));

  // Group into daily buckets (min/max) for a simple 5-day outlook
  const dayMap = {};
  data.list.forEach((item) => {
    const date = item.dt_txt.split(' ')[0];
    if (!dayMap[date]) {
      dayMap[date] = { min: item.main.temp, max: item.main.temp, icons: [], conditions: [] };
    }
    dayMap[date].min = Math.min(dayMap[date].min, item.main.temp);
    dayMap[date].max = Math.max(dayMap[date].max, item.main.temp);
    dayMap[date].icons.push(item.weather?.[0]?.icon);
    dayMap[date].conditions.push(item.weather?.[0]?.main);
  });

  const daily = Object.entries(dayMap).map(([date, v]) => ({
    date,
    tempMinC: v.min,
    tempMaxC: v.max,
    icon: v.icons[Math.floor(v.icons.length / 2)],
    condition: v.conditions[Math.floor(v.conditions.length / 2)],
  }));

  return { city: data.city?.name, country: data.city?.country, hourly, daily };
}

async function cachedFetch(cacheKey, fetcher) {
  const cached = cache.get(cacheKey);
  if (cached) return { data: cached, fromCache: true };
  const data = await fetcher();
  cache.set(cacheKey, data);
  return { data, fromCache: false };
}

// ---------- Routes ----------

app.get('/', (req, res) => {
  res.json({
    name: 'Weather App Backend',
    status: 'running',
    endpoints: [
      'GET /api/weather/city/:city',
      'GET /api/weather/coords?lat=&lon=',
      'GET /api/forecast/city/:city',
      'GET /api/forecast/coords?lat=&lon=',
      'GET /api/search?q=',
    ],
  });
});

app.get('/api/weather/city/:city', async (req, res) => {
  if (!requireApiKey(res)) return;
  try {
    const { city } = req.params;
    const units = req.query.units || 'metric';
    const key = `current_city_${city.toLowerCase()}_${units}`;
    const { data, fromCache } = await cachedFetch(key, async () => {
      const resp = await axios.get(`${BASE_URL}/weather`, {
        params: { q: city, appid: API_KEY, units },
      });
      return normalizeCurrent(resp.data);
    });
    res.json({ ...data, fromCache });
  } catch (err) {
    handleAxiosError(err, res);
  }
});

app.get('/api/weather/coords', async (req, res) => {
  if (!requireApiKey(res)) return;
  try {
    const { lat, lon } = req.query;
    if (!lat || !lon) return res.status(400).json({ error: 'lat and lon are required' });
    const units = req.query.units || 'metric';
    const key = `current_coords_${lat}_${lon}_${units}`;
    const { data, fromCache } = await cachedFetch(key, async () => {
      const resp = await axios.get(`${BASE_URL}/weather`, {
        params: { lat, lon, appid: API_KEY, units },
      });
      return normalizeCurrent(resp.data);
    });
    res.json({ ...data, fromCache });
  } catch (err) {
    handleAxiosError(err, res);
  }
});

app.get('/api/forecast/city/:city', async (req, res) => {
  if (!requireApiKey(res)) return;
  try {
    const { city } = req.params;
    const units = req.query.units || 'metric';
    const key = `forecast_city_${city.toLowerCase()}_${units}`;
    const { data, fromCache } = await cachedFetch(key, async () => {
      const resp = await axios.get(`${BASE_URL}/forecast`, {
        params: { q: city, appid: API_KEY, units },
      });
      return normalizeForecast(resp.data);
    });
    res.json({ ...data, fromCache });
  } catch (err) {
    handleAxiosError(err, res);
  }
});

app.get('/api/forecast/coords', async (req, res) => {
  if (!requireApiKey(res)) return;
  try {
    const { lat, lon } = req.query;
    if (!lat || !lon) return res.status(400).json({ error: 'lat and lon are required' });
    const units = req.query.units || 'metric';
    const key = `forecast_coords_${lat}_${lon}_${units}`;
    const { data, fromCache } = await cachedFetch(key, async () => {
      const resp = await axios.get(`${BASE_URL}/forecast`, {
        params: { lat, lon, appid: API_KEY, units },
      });
      return normalizeForecast(resp.data);
    });
    res.json({ ...data, fromCache });
  } catch (err) {
    handleAxiosError(err, res);
  }
});

// City search / autocomplete (geocoding)
app.get('/api/search', async (req, res) => {
  if (!requireApiKey(res)) return;
  try {
    const q = req.query.q;
    if (!q) return res.status(400).json({ error: 'q is required' });
    const key = `search_${q.toLowerCase()}`;
    const { data, fromCache } = await cachedFetch(key, async () => {
      const resp = await axios.get(`${GEO_URL}/direct`, {
        params: { q, limit: 5, appid: API_KEY },
      });
      return resp.data.map((c) => ({
        name: c.name,
        state: c.state,
        country: c.country,
        lat: c.lat,
        lon: c.lon,
      }));
    });
    res.json({ results: data, fromCache });
  } catch (err) {
    handleAxiosError(err, res);
  }
});

function handleAxiosError(err, res) {
  console.error(err.message);
  if (err.response) {
    return res.status(err.response.status).json({
      error: err.response.data?.message || 'Upstream weather API error',
    });
  }
  res.status(500).json({ error: 'Internal server error' });
}

app.use((req, res) => {
  res.status(404).json({ error: 'Not found' });
});

app.listen(PORT, () => {
  console.log(`🌦  Weather backend running on http://localhost:${PORT}`);
});
