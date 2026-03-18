import { randomBytes } from 'node:crypto';

export const generateQrToken = (): string => randomBytes(24).toString('hex');
