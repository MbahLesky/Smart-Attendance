export interface ApiErrorResponse {
  success: false;
  message: string;
  error: {
    code: string;
    details?: unknown;
  };
}

export interface ApiSuccessResponse<T> {
  success: true;
  message: string;
  data: T;
}
