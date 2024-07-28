import { AbstractControl, ValidatorFn } from '@angular/forms';

export function youtubeUrlValidator(): ValidatorFn {
  return (control: AbstractControl): { [key: string]: any } | null => {
    const url = control.value;
    if (!url) {
      return null;
    }
    const youtubeRegex = /^(https?\:\/\/)?(www\.youtube\.com|youtu\.be)\/.+$/;
    const valid = youtubeRegex.test(url);
    return valid ? null : { youtubeUrl: { value: url } };
  };
}