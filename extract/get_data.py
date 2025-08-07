import vk_api
import pandas as pd
from datetime import datetime
import getpass as gp

# Безопасный ввод токена
ACCESS_TOKEN = gp.getpass('Вставьте ваш VK Access Token и нажмите Enter: ')

# Вводим ID страницы
USER_ID = input('Введите ID пользователя для анализа: ')

# Инициализация сессии
vk_session = vk_api.VkApi(token=ACCESS_TOKEN)
vk = vk_session.get_api()

print("\nНачинаю сбор данных...")

# Сбор данных со стены
wall = vk.wall.get(owner_id=USER_ID, count=100)

posts_data = []
for post in wall['items']:
    post_date = datetime.fromtimestamp(post['date'])
    likes_count = post['likes']['count']
    
    posts_data.append({
        'post_date': post_date,
        'likes_count': likes_count
    })

# Создаем таблицу
df = pd.DataFrame(posts_data)

# Сохраняем данные в CSV-файл
df.to_csv('vk_posts.csv', index=False)

print("\nСоздан файл vk_posts.csv.")

# Показываем первые 5 строк
print(df.head())
