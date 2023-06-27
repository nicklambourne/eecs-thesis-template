import argparse
import os
import pathlib


def insert_sha(file_path: str, sha: str, include_dir: bool = False) -> str:
    path = pathlib.Path(file_path)
    if not path.exists():
        raise FileNotFoundError(f"File {file_path} does not exist.")
    if not path.is_file():
        raise FileExistsError(f"{file_path} is not a file.")
    short_sha = sha[:7]
    stem = path.stem
    directory = path.parent
    extension = path.suffix
    return f"{str(directory) + os.sep if include_dir else ''}{stem}-{short_sha}{extension}"
    

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("file_path", type=str)
    parser.add_argument("sha", type=str)  
    parser.add_argument("-d", "--dir", action='store_true')   
    args = parser.parse_args()
    print(insert_sha(file_path=args.file_path, sha=args.sha, include_dir=args.dir))