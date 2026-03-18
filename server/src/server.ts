import { env } from './config/env';

import { app } from './app';

app.listen(env.PORT, () => {
  console.log(
    `Smart Attendance backend listening on port ${env.PORT} in ${env.NODE_ENV} mode.`,
  );
});
