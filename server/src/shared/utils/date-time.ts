import { BadRequestError } from '../errors';

const normalizeTime = (value: string): string =>
  value.length === 5 ? `${value}:00` : value;

export const buildUtcDateTime = (date: string, time: string): Date => {
  const dateTime = new Date(`${date}T${normalizeTime(time)}Z`);

  if (Number.isNaN(dateTime.getTime())) {
    throw new BadRequestError('Invalid date/time combination.');
  }

  return dateTime;
};

export const isSameUtcDate = (date: string, candidate: Date): boolean => {
  return candidate.toISOString().slice(0, 10) === date;
};
